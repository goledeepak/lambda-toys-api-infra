
param cosmosDbAccountName string = 'financedbaccount'
param sqlDbName string = 'financedatabase'
param sqlcontainername string = 'employee_tbl'
param location string = 'centralindia'



resource virtualNetwork 'Microsoft.Network/virtualNetworks@2023-09-01' = {
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


resource cosmosDBaccount 'Microsoft.DocumentDB/databaseAccounts@2023-11-15' = {
  name: cosmosDbAccountName
  location: location
  properties: {    
    databaseAccountOfferType: 'Standard'    
    locations: [
      {
        failoverPriority: 0
        isZoneRedundant: false
        locationName: location
      }
    ]
  }
}



resource database 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases@2023-11-15' = {
  name: '${cosmosDBaccount.name}/${sqlDbName}-sqldb'
  properties: {
    resource: {
      id: '${sqlDbName}-sqldb'
    }
  }
}



resource container 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers@2023-11-15' = {
  name: '${database.name}/${sqlcontainername}'
  properties: {
    resource: {
      id: sqlcontainername
      partitionKey: {
        paths: [
          '/myPartitionKey'
        ]
        kind: 'Hash'
      }     
    }
    options: {
      throughput: 400
    }
  }
}





resource privateDNSZone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: 'privatelink.documents.azure.com'
  location: 'global'
}


resource privateDNSNetworkLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  name: 'private-DNS-link'
  location: 'global'
  parent: privateDNSZone
  properties:{
    registrationEnabled: true
    virtualNetwork: {
      id: virtualNetwork.id
    }
  }
}


resource privateEndpoint 'Microsoft.Network/privateEndpoints@2023-09-01' = {
  name: 'private-End-Point'
  location: location
  properties: {
    privateLinkServiceConnections: [
      {
        name: 'service_name_DB'
        properties: {
          privateLinkServiceId: cosmosDBaccount.id
          groupIds: [
            'SQL'
          ]
        }
      }
    ]
    subnet: {
      id: virtualNetwork.properties.subnets[0].id
    }
  }
}


resource cosmosPrivateEndpointDnsLink 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2023-09-01' = {
  name: 'cosmosPrivateEndpointDnsLinkName'
  parent: privateEndpoint
  properties: {
    privateDnsZoneConfigs:[
      { 
        name: 'PrivateEndpoint.documents.azure.com'
        properties:{
          privateDnsZoneId: privateDNSZone.id
        }
      }
    ]
  }
}
