@description('Virtual Network resource group name')
param vnetResourceGroupName string = 'central-india-RG'

@description('Virtual Network name')
param vnetName string = 'DevopsVNET'

@description('Virtual Network subnet name')
param vnetSubnetName string = 'Subnet-1'

param virtualMachines_machine_strorage_test_name string = 'machine-strorage-test'
param disks_machine_strorage_test_OsDisk_1_4c4ea6a621b743c5bd36e07a1373745e_externalid string = '/subscriptions/73e331b8-28c4-4be6-b9ab-a4eb4b1ee42e/resourceGroups/${vnetResourceGroupName}/providers/Microsoft.Compute/disks/machine-strorage-test_OsDisk_1_4c4ea6a621b743c5bd36e07a1373745e'
param networkInterfaces_machine_strorage_test344_externalid string = '/subscriptions/73e331b8-28c4-4be6-b9ab-a4eb4b1ee42e/resourceGroups/${vnetResourceGroupName}/providers/Microsoft.Network/networkInterfaces/machine-strorage-test344'
param location string = 'centralindia'


// Import the existing vnet and subnet to get the subnet id for deployment
resource vnet 'Microsoft.Network/virtualNetworks@2022-11-01' existing = {
  name: vnetName
  scope: resourceGroup(vnetResourceGroupName)
}

resource subnet 'Microsoft.Network/virtualNetworks/subnets@2022-11-01' existing = {
  name: vnetSubnetName
  parent: vnet
}

resource networkInterface 'Microsoft.Network/networkInterfaces@2023-09-01' = {
  name: 'networkInterfaceName'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'name1981546985'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: subnet.id
          }
        }
      }
    ]
  }
}




resource virtualMachines_machine_strorage_test_name_resource 'Microsoft.Compute/virtualMachines@2023-03-01' = {
  name: virtualMachines_machine_strorage_test_name
  location: 'southindia'
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_B2s'
    }
    additionalCapabilities: {
      hibernationEnabled: false
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2022-datacenter-azure-edition'
        version: 'latest'
      }
      osDisk: {
        osType: 'Windows'
        name: '${virtualMachines_machine_strorage_test_name}_OsDisk_1_4c4ea6a621b743c5bd36e07a1373745e'
        createOption: 'FromImage'
        caching: 'ReadWrite'
        managedDisk: {
          storageAccountType: 'Standard_LRS'          
        }
        deleteOption: 'Delete'
        diskSizeGB: 127
      }
      dataDisks: []
      diskControllerType: 'SCSI'
    }
    osProfile: {
      computerName: 'machine-strorag'
      adminUsername: 'deepakgole'
      windowsConfiguration: {
        provisionVMAgent: true
        enableAutomaticUpdates: true
        patchSettings: {
          patchMode: 'AutomaticByOS'
          assessmentMode: 'ImageDefault'
          enableHotpatching: false
        }
        enableVMAgentPlatformUpdates: false
      }
      secrets: []
      allowExtensionOperations: true
      requireGuestProvisionSignal: true
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterface.id
          properties: {
            deleteOption: 'Delete'
          }
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
      }
    }
  }
}
