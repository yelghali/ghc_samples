param(
    [string] $AzPath = 'C:\Program Files\Microsoft SDKs\Azure\CLI2\wbin\az.cmd',
    [Parameter(Mandatory = $true)]
    [string] $SubscriptionId,
    [Parameter(Mandatory = $true)]
    [string] $ResourceGroupName,
    [string] $OutputPath = 'security-guidelines.md'
)

$ErrorActionPreference = 'Stop'

if (-not (Test-Path $AzPath)) {
    $azCommand = Get-Command az -ErrorAction SilentlyContinue
    if (-not $azCommand) {
        throw 'Azure CLI was not found. Set -AzPath to az.cmd or add az to PATH.'
    }
    $AzPath = $azCommand.Source
}

& $AzPath account set --subscription $SubscriptionId

$account = & $AzPath account show --output json | ConvertFrom-Json
$resources = & $AzPath resource list --resource-group $ResourceGroupName --output json | ConvertFrom-Json

$advisorSecurity = @()
try {
    $advisorSecurity = & $AzPath advisor recommendation list --category Security --output json | ConvertFrom-Json
}
catch {
    $advisorError = $_.Exception.Message
}

$storageFindings = @()
foreach ($resource in @($resources | Where-Object { $_.type -eq 'Microsoft.Storage/storageAccounts' })) {
    $storage = & $AzPath storage account show --ids $resource.id --output json | ConvertFrom-Json
    $storageFindings += [pscustomobject]@{
        name = $storage.name
        publicNetworkAccess = $storage.publicNetworkAccess
        allowBlobPublicAccess = $storage.allowBlobPublicAccess
        allowSharedKeyAccess = $storage.allowSharedKeyAccess
        enableHttpsTrafficOnly = $storage.enableHttpsTrafficOnly
        minimumTlsVersion = $storage.minimumTlsVersion
        defaultAction = $storage.networkRuleSet.defaultAction
        identityType = $storage.identity.type
    }
}

$enhancements = @()
foreach ($finding in $storageFindings) {
    if ($finding.identityType -ne 'SystemAssigned' -and $finding.identityType -ne 'UserAssigned' -and $finding.identityType -ne 'SystemAssigned, UserAssigned') {
        $enhancements += [pscustomobject]@{
            Area = 'Identity'
            Detected = ('Storage account `{0}` does not have a managed identity configured.' -f $finding.name)
            WhyItMatters = 'Managed identity enables secretless integration with Azure services and supports least-privilege access patterns.'
            RecommendedEnhancement = 'Enable system-assigned or user-assigned managed identity when the storage account participates in automation, diagnostics, encryption, or service integrations.'
            Validation = ('az storage account show --name {0} --resource-group {1} --query identity' -f $finding.name, $ResourceGroupName)
        }
    }
    if ($finding.defaultAction -ne 'Deny') {
        $enhancements += [pscustomobject]@{
            Area = 'Network access'
            Detected = ('Storage account `{0}` network default action is `{1}`.' -f $finding.name, $finding.defaultAction)
            WhyItMatters = 'Deny-by-default network rules reduce exposure if public network access is re-enabled or exceptions are added later.'
            RecommendedEnhancement = 'Set network default action to Deny and add explicit private endpoint, trusted service, or subnet rules required by the workload.'
            Validation = ('az storage account show --name {0} --resource-group {1} --query networkRuleSet.defaultAction' -f $finding.name, $ResourceGroupName)
        }
    }
    if ($finding.publicNetworkAccess -ne 'Disabled') {
        $enhancements += [pscustomobject]@{
            Area = 'Public exposure'
            Detected = ('Storage account `{0}` public network access is `{1}`.' -f $finding.name, $finding.publicNetworkAccess)
            WhyItMatters = 'Public network reachability increases exposure and requires stronger compensating controls.'
            RecommendedEnhancement = 'Disable public network access for private workloads, or document the business exception and enforce narrow network rules.'
            Validation = ('az storage account show --name {0} --resource-group {1} --query publicNetworkAccess' -f $finding.name, $ResourceGroupName)
        }
    }
    if ($finding.allowBlobPublicAccess -ne $false) {
        $enhancements += [pscustomobject]@{
            Area = 'Data exposure'
            Detected = ('Storage account `{0}` allows blob public access.' -f $finding.name)
            WhyItMatters = 'Anonymous blob access can expose data if a container is misconfigured.'
            RecommendedEnhancement = 'Disable blob public access unless a reviewed workload explicitly requires anonymous content delivery.'
            Validation = ('az storage account show --name {0} --resource-group {1} --query allowBlobPublicAccess' -f $finding.name, $ResourceGroupName)
        }
    }
    if ($finding.allowSharedKeyAccess -ne $false) {
        $enhancements += [pscustomobject]@{
            Area = 'Authentication'
            Detected = ('Storage account `{0}` allows shared key access.' -f $finding.name)
            WhyItMatters = 'Shared keys are broad, long-lived credentials and are harder to govern than Entra ID authorization.'
            RecommendedEnhancement = 'Disable shared key access after confirming all callers support Entra ID, managed identity, or scoped SAS patterns.'
            Validation = ('az storage account show --name {0} --resource-group {1} --query allowSharedKeyAccess' -f $finding.name, $ResourceGroupName)
        }
    }
    if ($finding.enableHttpsTrafficOnly -ne $true) {
        $enhancements += [pscustomobject]@{
            Area = 'Transport security'
            Detected = ('Storage account `{0}` does not enforce HTTPS-only traffic.' -f $finding.name)
            WhyItMatters = 'HTTP allows plaintext transport and weakens confidentiality guarantees.'
            RecommendedEnhancement = 'Enable HTTPS-only traffic for the storage account.'
            Validation = ('az storage account show --name {0} --resource-group {1} --query enableHttpsTrafficOnly' -f $finding.name, $ResourceGroupName)
        }
    }
    if ($finding.minimumTlsVersion -ne 'TLS1_2' -and $finding.minimumTlsVersion -ne 'TLS1_3') {
        $enhancements += [pscustomobject]@{
            Area = 'Transport security'
            Detected = ('Storage account `{0}` minimum TLS version is `{1}`.' -f $finding.name, $finding.minimumTlsVersion)
            WhyItMatters = 'Older TLS versions do not meet current Azure security baseline expectations.'
            RecommendedEnhancement = 'Set minimum TLS to TLS1_2 or later and validate legacy client compatibility.'
            Validation = ('az storage account show --name {0} --resource-group {1} --query minimumTlsVersion' -f $finding.name, $ResourceGroupName)
        }
    }
}

$advisorSecurityEnhancementKeys = @{}
foreach ($rec in @($advisorSecurity)) {
    $problem = $rec.shortDescription.problem
    $solution = $rec.shortDescription.solution
    if (-not $problem) { $problem = $rec.impactedValue }
    if (-not $solution) { $solution = 'Review the Azure Advisor or Defender recommendation details and remediate after workload-owner validation.' }
    $key = '{0}|{1}' -f $problem, $solution
    if ($advisorSecurityEnhancementKeys.ContainsKey($key)) {
        continue
    }
    $advisorSecurityEnhancementKeys[$key] = $true
    $enhancements += [pscustomobject]@{
        Area = 'Azure Advisor Security'
        Detected = $problem
        WhyItMatters = 'Azure security posture signals indicate an issue that may increase exposure, weaken governance, or reduce resilience.'
        RecommendedEnhancement = $solution
        Validation = 'az advisor recommendation list --category Security --output table'
    }
}

$lines = @()
$lines += '# Azure Security Configuration Guidelines'
$lines += ''
$lines += '## Azure Context'
$lines += ''
$lines += ('- Subscription: `{0}`' -f $account.name)
$lines += ('- Subscription ID: `{0}`' -f $account.id)
$lines += ('- Tenant ID: `{0}`' -f $account.tenantId)
$lines += ('- Resource group: `{0}`' -f $ResourceGroupName)
$lines += ''
$lines += '## Observed Configuration'
$lines += ''
$lines += "- Resource count: $(@($resources).Count)"
$lines += "- Storage accounts inspected: $($storageFindings.Count)"
foreach ($finding in $storageFindings) {
    $lines += ('- Storage `{0}`: publicNetworkAccess=`{1}`, allowBlobPublicAccess=`{2}`, allowSharedKeyAccess=`{3}`, httpsOnly=`{4}`, minTls=`{5}`, networkDefaultAction=`{6}`, identity=`{7}`' -f $finding.name, $finding.publicNetworkAccess, $finding.allowBlobPublicAccess, $finding.allowSharedKeyAccess, $finding.enableHttpsTrafficOnly, $finding.minimumTlsVersion, $finding.defaultAction, $finding.identityType)
}
$lines += ''
$lines += '## Azure Advisor / Defender Findings'
$lines += ''
if ($advisorError) {
    $lines += ('- Advisor security query failed or was unavailable: `{0}`' -f $advisorError)
}
else {
    $lines += "- Advisor security recommendations: $(@($advisorSecurity).Count)"
    foreach ($rec in @($advisorSecurity | Sort-Object -Property @{ Expression = { '{0}|{1}' -f $_.shortDescription.problem, $_.shortDescription.solution } } -Unique | Select-Object -First 10)) {
        $lines += "- Security: $($rec.shortDescription.problem) -> $($rec.shortDescription.solution)"
    }
}
$lines += ''
$lines += '## Detected Enhancements'
$lines += ''
if ($enhancements.Count -eq 0) {
    $lines += '- No specific security enhancements were detected in the reviewed scope. Keep Advisor, Defender, Policy, PSRule, and deployment what-if checks under regular review.'
}
else {
    $lines += '| Area | Detected item | Why it matters | Recommended enhancement | Validation/action |'
    $lines += '| --- | --- | --- | --- | --- |'
    foreach ($item in $enhancements) {
        $lines += ('| {0} | {1} | {2} | {3} | `{4}` |' -f $item.Area, $item.Detected, $item.WhyItMatters, $item.RecommendedEnhancement, $item.Validation)
    }
}
$lines += ''
$lines += '## Baseline Guidelines'
$lines += ''
$lines += '- Verify explicitly: require managed identity or Entra ID auth where supported; avoid shared keys and long-lived secrets.'
$lines += '- Use least privilege: scope RBAC narrowly and review role assignments for workload identities and operators.'
$lines += '- Assume breach: disable public network access where private access is available, deny by default on network ACLs, and enable diagnostics.'
$lines += '- Protect confidentiality: enforce HTTPS-only, TLS 1.2 or later, encryption at rest, private endpoints for sensitive data stores, and secret-free outputs.'
$lines += '- Protect integrity: use immutable or soft-delete capabilities where supported, keep API versions current, and validate IaC with build, what-if, policy, and PSRule.'
$lines += '- Protect availability: ensure security controls do not block recovery paths, and apply equivalent security controls to backup/DR resources.'
$lines += '- Sustain posture: review Azure Advisor/Defender recommendations regularly and compare deployed config against intended Bicep after every release.'
$lines += '- Treat this report as guidance. Confirm business exceptions, data classification, network topology, and operational ownership before remediation.'

$lines | Set-Content -Path $OutputPath -Encoding utf8
Write-Output "Wrote $OutputPath"
