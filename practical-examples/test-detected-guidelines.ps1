param(
    [string] $AzPath = 'C:\Program Files\Microsoft SDKs\Azure\CLI2\wbin\az.cmd',
    [Parameter(Mandatory = $true)]
    [string] $SubscriptionId,
    [Parameter(Mandatory = $true)]
    [string] $ResourceGroupName,
    [string] $FinOpsReportPath = 'practical-examples\finops-guidelines-2026-06-11.md',
    [string] $SecurityReportPath = 'practical-examples\security-guidelines-2026-06-11.md'
)

$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent $PSScriptRoot
Push-Location $repoRoot
try {
    & '.\finops-azure\samples\advisor-finops-review.ps1' -AzPath $AzPath -SubscriptionId $SubscriptionId -ResourceGroupName $ResourceGroupName -OutputPath $FinOpsReportPath
    & '.\secure-bicep-iac\samples\read-config-and-security-guidelines.ps1' -AzPath $AzPath -SubscriptionId $SubscriptionId -ResourceGroupName $ResourceGroupName -OutputPath $SecurityReportPath

    $checks = @(
        @{ Name = 'FinOps report exists'; Passed = Test-Path $FinOpsReportPath },
        @{ Name = 'Security report exists'; Passed = Test-Path $SecurityReportPath }
    )

    $finops = Get-Content -Path $FinOpsReportPath -Raw
    $security = Get-Content -Path $SecurityReportPath -Raw

    $checks += @{ Name = 'FinOps has detected enhancements section'; Passed = $finops -match '## Detected Enhancements' }
    $checks += @{ Name = 'FinOps has actionable table'; Passed = $finops -match '\| Area \| Detected item \| Why it matters \| Recommended enhancement \| Validation/action \|' }
    $checks += @{ Name = 'FinOps includes Advisor or resource-driven enhancements'; Passed = $finops -match 'Azure Advisor Cost|Tagging|Network cost hygiene|Storage cost hygiene' }
    $checks += @{ Name = 'Security has detected enhancements section'; Passed = $security -match '## Detected Enhancements' }
    $checks += @{ Name = 'Security has actionable table'; Passed = $security -match '\| Area \| Detected item \| Why it matters \| Recommended enhancement \| Validation/action \|' }
    $checks += @{ Name = 'Security includes config-driven enhancements'; Passed = $security -match 'Identity|Network access|Public exposure|Data exposure|Authentication|Transport security|Azure Advisor Security' }

    $failed = @($checks | Where-Object { -not $_.Passed })
    $checks | ForEach-Object {
        if ($_.Passed) {
            Write-Host ('PASS: {0}' -f $_.Name)
        }
        else {
            Write-Host ('FAIL: {0}' -f $_.Name)
        }
    }

    if ($failed.Count -gt 0) {
        throw ('Detected guideline test failed: {0}' -f (($failed | ForEach-Object { $_.Name }) -join '; '))
    }

    Write-Host 'Detected guideline reports are actionable and finding-driven.'
}
finally {
    Pop-Location
}