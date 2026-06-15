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

@description('Azure region for the storage account.')
param location string

var storageAccountName = take('st${workloadName}${environmentName}${uniqueString(resourceGroup().id)}', 24)

resource storageAccount 'Microsoft.Storage/storageAccounts@2025-01-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    allowBlobPublicAccess: false
    minimumTlsVersion: 'TLS1_2'
    supportsHttpsTrafficOnly: true
    publicNetworkAccess: 'Disabled'
  }
}

output name string = storageAccount.name
output id string = storageAccount.id
