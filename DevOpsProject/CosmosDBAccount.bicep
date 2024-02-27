
param cosmosDbAccountName string = 'financedbaccount'
param sqlDbName string = 'financedatabase1'
param sqlcontainername string = 'employee_tbl'
param location string = 'centralindia'


resource account 'Microsoft.DocumentDB/databaseAccounts@2023-11-15' = {
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
  name: '${account.name}/${sqlDbName}-sqldb'
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
