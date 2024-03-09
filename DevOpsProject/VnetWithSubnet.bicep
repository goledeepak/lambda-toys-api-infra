
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
          addressPrefix: '10.0.0.0/26'
          networkSecurityGroup: {
            id: securityGrp1.id  
          }
        }
      } 
      {
        name: 'Subnet-2'
        properties: {
          addressPrefix: '10.0.0.64/26' 
          networkSecurityGroup: {
            id: securityGrp2.id
          }         
        }
      }

    ]
  }
}


resource gatewaySubnetOps 'Microsoft.Network/virtualNetworks/subnets@2023-09-01' = {
  parent: virtualNetwork
  name: 'GatewaySubnet'
  properties: {
    addressPrefix: '10.0.0.128/26'
  }  
}


resource securityGrp1 'Microsoft.Network/networkSecurityGroups@2023-09-01' = {
  name: 'securityGrpSubnet1'
  location: location
  properties:{
    securityRules:[
      {
        name: 'Allow-WEB-HTTP'
        properties: {
          priority: 200
          access: 'Allow'
          direction: 'Inbound'
          destinationPortRange: '80'
          protocol: 'Tcp'
          sourcePortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
        }    
      }      
      {
        name: 'Allow-WEB-HTTPS'
        properties: {
          priority: 300
          access: 'Allow'
          direction: 'Inbound'
          destinationPortRange: '443'
          protocol: 'Tcp'
          sourcePortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
        }    
      }
    ]
  }
}


resource securityGrp2 'Microsoft.Network/networkSecurityGroups@2023-09-01' = {
  name: 'securityGrpSubnet2'
  location: location
  properties:{
    securityRules:[
      {
        name: 'Allow-WEB-HTTP'
        properties: {
          priority: 200
          access: 'Allow'
          direction: 'Inbound'
          destinationPortRange: '80'
          protocol: 'Tcp'
          sourcePortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
        }    
      }      
      {
        name: 'Allow-WEB-HTTPS'
        properties: {
          priority: 300
          access: 'Allow'
          direction: 'Inbound'
          destinationPortRange: '443'
          protocol: 'Tcp'
          sourcePortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
        }    
      }
    ]
  }
}

