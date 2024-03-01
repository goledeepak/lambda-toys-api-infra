
param location string = 'centralindia'

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2019-11-01' = {
  name: 'DevopsVNET'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'Subnet-1'
        properties: {
          addressPrefix: '10.0.0.0/24'
        }
      }      
    ]
  }
}




'az group create --name central-india-RG --location centralindia'
'az deployment group create -g central-india-RG --template-file KeyVault.bicep'
