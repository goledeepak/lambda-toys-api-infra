param location string = 'centralindia'
param principalId string = '9b5eb604-51fc-4c4f-a87a-af9e35e886c0'


resource keyVault 'Microsoft.KeyVault/vaults@2023-07-01' = {
  name: 'keyVaultDemoDeepakG1981'
  location: location
  properties: {
    enabledForDeployment: true
    enabledForTemplateDeployment: true
    enabledForDiskEncryption: true
    enableRbacAuthorization: true
    tenantId: tenant().tenantId    
    sku: {
      name: 'standard'
      family: 'A'
    }
  }
}


@description('This is the built-in key Vault Administrator role.')
resource keyVaultAdministratorRoleDefinition 'Microsoft.Authorization/roleDefinitions@2022-05-01-preview' existing = {
  scope: subscription()
  name: '00482a5a-887f-4fb3-b363-3b7fe8e74483'
}


resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(resourceGroup().id, principalId, keyVaultAdministratorRoleDefinition.id)  
  properties: {
    roleDefinitionId: keyVaultAdministratorRoleDefinition.id
    principalId: principalId
    principalType: 'User'
  }
}


resource keyVaultSecret 'Microsoft.KeyVault/vaults/secrets@2023-07-01' = {
  parent: keyVault
  name: 'NewSecretPassword'
  properties: {
    contentType: 'Text'
    value: 'DeepakGole123'
  }
}


