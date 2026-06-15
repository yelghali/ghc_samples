targetScope = 'resourceGroup'

@description('Short workload name used in resource names.')
@minLength(2)
@maxLength(10)
param workloadName string

@description('Deployment environment name.')
@allowed([
  'dev'
  'test'
  'prod'
])
param environmentName string

@description('Azure region for resources.')
param location string = resourceGroup().location

module storage './modules/storage-account/main.bicep' = {
  name: 'storage-${workloadName}-${environmentName}'
  params: {
    workloadName: workloadName
    environmentName: environmentName
    location: location
  }
}

output storageAccountName string = storage.outputs.name
