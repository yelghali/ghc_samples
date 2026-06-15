param(
    [string] $AzPath = 'C:\Program Files\Microsoft SDKs\Azure\CLI2\wbin\az.cmd',
    [string] $SubscriptionId = '292e62e6-54a8-4c6a-b996-0c83f8cc29d0',
    [string] $TenantId = '5dc82be3-90ab-4f72-a0f2-b2557ba694e3',
    [string] $Location = 'eastus',
    [string] $ResourceGroupName = 'rg-ghc-samples-showcase'
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
& $AzPath account show --query "{name:name,id:id,tenantId:tenantId,user:user.name}" --output table

Write-Host 'Building Bicep samples...'
& $AzPath bicep build --file 'arm-to-bicep-conversion/samples/converted.main.bicep'
& $AzPath bicep build --file 'bicep-to-modules/samples/main.bicep'
& $AzPath bicep build --file 'secure-bicep-iac/samples/secure-storage.bicep'

Write-Host 'Ensuring showcase resource group exists...'
& $AzPath group create --name $ResourceGroupName --location $Location --tags purpose=ghc-samples environment=showcase --output table

Write-Host 'Running non-destructive what-if for ARM-to-Bicep sample...'
& $AzPath deployment group what-if `
    --resource-group $ResourceGroupName `
    --template-file 'arm-to-bicep-conversion/samples/converted.main.bicep' `
    --parameters namePrefix=ghc location=$Location

Write-Host 'Running non-destructive what-if for module sample...'
& $AzPath deployment group what-if `
    --resource-group $ResourceGroupName `
    --template-file 'bicep-to-modules/samples/main.bicep' `
    --parameters workloadName=ghc environmentName=dev location=$Location

Write-Host 'Running read-only resource inventory...'
& $AzPath resource list --resource-group $ResourceGroupName --query "[].{name:name,type:type,location:location}" --output table

Write-Host 'Done. No sample resources are deployed by this script except the showcase resource group.'
