param(
    [string] $AzPath = 'C:\Program Files\Microsoft SDKs\Azure\CLI2\wbin\az.cmd',
    [Parameter(Mandatory = $true)]
    [string] $SubscriptionId,
    [string] $ResourceGroupName,
    [string] $OutputPath = 'finops-guidelines.md'
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

$resourceArgs = @('resource', 'list', '--output', 'json')
if ($ResourceGroupName) {
    $resourceArgs += @('--resource-group', $ResourceGroupName)
}
$resources = & $AzPath @resourceArgs | ConvertFrom-Json

$advisorCost = @()
$advisorPerformance = @()
try {
    $advisorCost = & $AzPath advisor recommendation list --category Cost --output json | ConvertFrom-Json
    $advisorPerformance = & $AzPath advisor recommendation list --category Performance --output json | ConvertFrom-Json
}
catch {
    $advisorError = $_.Exception.Message
}

$untaggedResources = @($resources | Where-Object { -not $_.tags -or $_.tags.PSObject.Properties.Count -eq 0 })
$storageAccounts = @($resources | Where-Object { $_.type -eq 'Microsoft.Storage/storageAccounts' })
$publicIps = @($resources | Where-Object { $_.type -eq 'Microsoft.Network/publicIPAddresses' })
$disks = @($resources | Where-Object { $_.type -eq 'Microsoft.Compute/disks' })

$enhancements = @()
foreach ($resource in $untaggedResources) {
    $enhancements += [pscustomobject]@{
        Area = 'Tagging'
        Detected = ('Resource `{0}` has no tags.' -f $resource.name)
        WhyItMatters = 'Missing ownership and cost-center tags make showback, chargeback, anomaly routing, and cleanup decisions harder.'
        RecommendedEnhancement = 'Apply required tags such as workload, environment, owner, and costCenter through IaC and Azure Policy.'
        Validation = ('az resource show --ids "{0}" --query tags' -f $resource.id)
    }
}

foreach ($resource in $publicIps) {
    $enhancements += [pscustomobject]@{
        Area = 'Network cost hygiene'
        Detected = ('Public IP `{0}` exists in the reviewed scope.' -f $resource.name)
        WhyItMatters = 'Unused or oversized public IP resources can create avoidable recurring cost and expand operational review scope.'
        RecommendedEnhancement = 'Confirm whether the public IP is attached and required; remove unused IPs or move ownership into a tagged workload module.'
        Validation = ('az network public-ip show --ids "{0}" --query "{name:name,ipAddress:ipAddress,ipConfiguration:ipConfiguration.id,sku:sku.name,tags:tags}"' -f $resource.id)
    }
}

foreach ($resource in $disks) {
    $enhancements += [pscustomobject]@{
        Area = 'Storage cost hygiene'
        Detected = ('Managed disk `{0}` exists in the reviewed scope.' -f $resource.name)
        WhyItMatters = 'Detached or oversized disks are common sources of silent spend.'
        RecommendedEnhancement = 'Check managedBy, SKU, size, and last-use evidence; delete orphaned disks or resize after workload-owner approval.'
        Validation = ('az disk show --ids "{0}" --query "{name:name,managedBy:managedBy,diskSizeGB:diskSizeGB,sku:sku.name,tags:tags}"' -f $resource.id)
    }
}

$advisorCostEnhancementKeys = @{}
foreach ($rec in @($advisorCost)) {
    $problem = $rec.shortDescription.problem
    $solution = $rec.shortDescription.solution
    if (-not $problem) { $problem = $rec.impactedValue }
    if (-not $solution) { $solution = 'Review the Azure Advisor recommendation details and apply after workload-owner validation.' }
    $key = '{0}|{1}' -f $problem, $solution
    if ($advisorCostEnhancementKeys.ContainsKey($key)) {
        continue
    }
    $advisorCostEnhancementKeys[$key] = $true
    $enhancements += [pscustomobject]@{
        Area = 'Azure Advisor Cost'
        Detected = $problem
        WhyItMatters = 'Azure Advisor identified a potential cost optimization opportunity based on platform telemetry.'
        RecommendedEnhancement = $solution
        Validation = 'az advisor recommendation list --category Cost --output table'
    }
}

$lines = @()
$lines += '# Azure FinOps Advisor Review'
$lines += ''
$lines += '## Azure Context'
$lines += ''
$lines += ('- Subscription: `{0}`' -f $account.name)
$lines += ('- Subscription ID: `{0}`' -f $account.id)
$lines += ('- Tenant ID: `{0}`' -f $account.tenantId)
if ($ResourceGroupName) {
    $lines += ('- Resource group scope: `{0}`' -f $ResourceGroupName)
}
$lines += ''
$lines += '## Observed Configuration'
$lines += ''
$lines += "- Resource count: $(@($resources).Count)"
$lines += "- Untagged resource count: $($untaggedResources.Count)"
$lines += "- Storage account count: $($storageAccounts.Count)"
$lines += "- Public IP count: $($publicIps.Count)"
$lines += "- Managed disk count: $($disks.Count)"
$lines += ''
$lines += '## Azure Advisor Findings'
$lines += ''
if ($advisorError) {
    $lines += ('- Advisor query failed or was unavailable: `{0}`' -f $advisorError)
}
else {
    $lines += "- Cost recommendations: $(@($advisorCost).Count)"
    $lines += "- Performance recommendations: $(@($advisorPerformance).Count)"
    foreach ($rec in @($advisorCost | Sort-Object -Property @{ Expression = { '{0}|{1}' -f $_.shortDescription.problem, $_.shortDescription.solution } } -Unique | Select-Object -First 10)) {
        $lines += "- Cost: $($rec.shortDescription.problem) -> $($rec.shortDescription.solution)"
    }
}
$lines += ''
$lines += '## Detected Enhancements'
$lines += ''
if ($enhancements.Count -eq 0) {
    $lines += '- No specific FinOps enhancements were detected in the reviewed scope. Keep Advisor, budgets, tags, and Cost Management exports under regular review.'
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
$lines += '- Use Azure Advisor Cost recommendations as the first prioritization input for rightsizing, shutdown, and burstable SKU opportunities.'
$lines += '- Validate Advisor savings against reservations, savings plans, negotiated discounts, workload criticality, performance requirements, and business calendars before actioning.'
$lines += '- Require workload, environment, owner, and cost-center tags for showback/chargeback and ownership routing.'
$lines += '- Configure budgets and alerts at the subscription/resource-group scope before deploying recurring workloads.'
$lines += '- Use Cost Management exports or FinOps hubs for durable reporting instead of relying only on portal views.'
$lines += '- Review public IPs, orphaned disks, unattached resources, and nonproduction always-on resources on a regular cadence.'
$lines += '- Treat this report as evidence plus guidance; it does not deploy, resize, delete, or purchase commitments.'

$lines | Set-Content -Path $OutputPath -Encoding utf8
Write-Output "Wrote $OutputPath"
