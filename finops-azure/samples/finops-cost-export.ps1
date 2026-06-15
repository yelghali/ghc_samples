param(
    [Parameter(Mandatory = $true)]
    [string] $Scope,

    [Parameter(Mandatory = $true)]
    [string] $StorageAccountId,

    [Parameter(Mandatory = $true)]
    [string] $ContainerName,

    [string] $ExportName = 'daily-focus-cost-export',

    [string] $Directory = 'cost-management/exports'
)

$ErrorActionPreference = 'Stop'

if (-not (Get-Module -ListAvailable -Name FinOpsToolkit)) {
    Write-Host 'Install with: Install-Module FinOpsToolkit -Scope CurrentUser'
    throw 'FinOpsToolkit PowerShell module is not installed.'
}

Import-Module FinOpsToolkit

New-FinOpsCostExport `
    -Name $ExportName `
    -Scope $Scope `
    -StorageAccountId $StorageAccountId `
    -StorageContainer $ContainerName `
    -StorageDirectory $Directory `
    -Recurrence Daily `
    -Format Parquet

Get-FinOpsCostExport -Scope $Scope -Name $ExportName
