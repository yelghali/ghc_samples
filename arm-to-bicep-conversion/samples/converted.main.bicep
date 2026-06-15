@description('Short prefix used for the storage account name.')
@minLength(3)
@maxLength(11)
param namePrefix string

@description('Azure region for the storage account.')
param location string = resourceGroup().location

var uniqueStorageAccountName = '${namePrefix}${uniqueString(resourceGroup().id)}'

resource storageAccount 'Microsoft.Storage/storageAccounts@2025-01-01' = {
  name: uniqueStorageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    supportsHttpsTrafficOnly: true
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: false
  }
}

output storageAccountName string = storageAccount.name
