$ErrorActionPreference = 'Continue'
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force
$az = 'C:\Program Files\Microsoft SDKs\Azure\CLI2\wbin\az.cmd'
$sub = '292e62e6-54a8-4c6a-b996-0c83f8cc29d0'
$rg = 'rg-ghc-samples-showcase'
$out1 = 'practical-examples\finops-guidelines-2026-06-11.md'
$out2 = 'practical-examples\security-guidelines-2026-06-11.md'
$finops = 'FAIL'
$security = 'FAIL'
try {
  & '.\finops-azure\samples\advisor-finops-review.ps1' -AzPath $az -SubscriptionId $sub -ResourceGroupName $rg -OutputPath $out1
  if (Test-Path $out1) { $finops = 'PASS' }
} catch { Write-Host ('FINOPS_ERROR: ' + $_.Exception.Message) }
try {
  & '.\secure-bicep-iac\samples\read-config-and-security-guidelines.ps1' -AzPath $az -SubscriptionId $sub -ResourceGroupName $rg -OutputPath $out2
  if (Test-Path $out2) { $security = 'PASS' }
} catch { Write-Host ('SECURITY_ERROR: ' + $_.Exception.Message) }
Write-Host '===RESULTS==='
Write-Host ('FinOps: ' + $finops + ' Path: ' + (Join-Path (Get-Location) $out1))
Write-Host ('Security: ' + $security + ' Path: ' + (Join-Path (Get-Location) $out2))
Write-Host '===FINOPS_FIRST_30==='
if (Test-Path $out1) { Get-Content -Path $out1 -TotalCount 30 } else { Write-Host 'Report not found.' }
Write-Host '===SECURITY_FIRST_30==='
if (Test-Path $out2) { Get-Content -Path $out2 -TotalCount 30 } else { Write-Host 'Report not found.' }
