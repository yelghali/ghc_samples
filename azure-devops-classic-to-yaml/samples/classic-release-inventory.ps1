<#
.SYNOPSIS
    OPTIONAL, APPROVAL-GATED. Snapshots Azure DevOps Classic release definitions,
    variable groups, and service connections to local JSON for offline Classic-to-YAML
    migration review.

.DESCRIPTION
    Classic RELEASE pipelines cannot be exported to YAML. This script captures the
    closest machine-readable starting point (the REST/CLI definition JSON) so the
    migration can be planned offline.

    This script requires LIVE Azure DevOps access and credentials. Only run it after
    the user has explicitly approved connecting to their organization. It performs
    read-only GET operations and writes JSON snapshots to an output folder. It does
    not modify any pipeline, variable group, or service connection.

    Prerequisites:
      az extension add --name azure-devops
      az devops login   # (PAT)  -- or --  az login

    MCP is not allowed in this workspace; this uses the Azure CLI azure-devops
    extension and REST API only.

.PARAMETER Organization
    Azure DevOps organization URL, e.g. https://dev.azure.com/contoso

.PARAMETER Project
    Azure DevOps project name.

.PARAMETER OutputPath
    Folder to write JSON snapshots into. Created if missing.

.EXAMPLE
    ./classic-release-inventory.ps1 -Organization https://dev.azure.com/contoso -Project Payments -OutputPath ./inventory
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$Organization,

    [Parameter(Mandatory = $true)]
    [string]$Project,

    [Parameter(Mandatory = $false)]
    [string]$OutputPath = "./classic-release-inventory"
)

$ErrorActionPreference = "Stop"

Write-Host "This script connects to a LIVE Azure DevOps organization and reads pipeline metadata." -ForegroundColor Yellow
$confirm = Read-Host "Type 'yes' to confirm you approve running a live, read-only inventory"
if ($confirm -ne "yes") {
    Write-Host "Aborted. Use the offline migration-inventory.template.json instead." -ForegroundColor Cyan
    return
}

if (-not (Get-Command az -ErrorAction SilentlyContinue)) {
    throw "Azure CLI (az) is not installed. Install it and run: az extension add --name azure-devops"
}

if (-not (Test-Path $OutputPath)) {
    New-Item -ItemType Directory -Path $OutputPath -Force | Out-Null
}

Write-Host "Snapshotting variable groups..." -ForegroundColor Green
az pipelines variable-group list --organization $Organization --project $Project --output json |
    Out-File -FilePath (Join-Path $OutputPath "variable-groups.json") -Encoding utf8

Write-Host "Snapshotting service connections..." -ForegroundColor Green
az devops service-endpoint list --organization $Organization --project $Project --output json |
    Out-File -FilePath (Join-Path $OutputPath "service-connections.json") -Encoding utf8

# Classic release definitions are not exposed by `az pipelines`; use the vsrm REST API.
Write-Host "Listing Classic release definitions via REST..." -ForegroundColor Green
$orgName = ($Organization.TrimEnd('/') -split '/')[-1]
$listUri = "https://vsrm.dev.azure.com/$orgName/$Project/_apis/release/definitions?api-version=7.1"
$definitions = az rest --method get --uri $listUri --resource "499b84ac-1321-427f-aa17-267ca6975798" --output json | ConvertFrom-Json

if ($definitions.value) {
    foreach ($def in $definitions.value) {
        $detailUri = "https://vsrm.dev.azure.com/$orgName/$Project/_apis/release/definitions/$($def.id)?api-version=7.1"
        $safeName = ($def.name -replace '[^\w\.-]', '_')
        Write-Host "  - $($def.name) (id $($def.id))" -ForegroundColor Gray
        az rest --method get --uri $detailUri --resource "499b84ac-1321-427f-aa17-267ca6975798" --output json |
            Out-File -FilePath (Join-Path $OutputPath "release-$($def.id)-$safeName.snapshot.json") -Encoding utf8
    }
}
else {
    Write-Host "No Classic release definitions found." -ForegroundColor Yellow
}

Write-Host "Done. Review the JSON snapshots in '$OutputPath' as the reference oracle for manual YAML migration." -ForegroundColor Green
Write-Host "Reminder: Classic release pipelines cannot be exported to YAML; migrate task by task." -ForegroundColor Yellow
