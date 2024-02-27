param virtualMachines_machine_strorage_test_name string = 'machine-strorage-test'
param disks_machine_strorage_test_OsDisk_1_4c4ea6a621b743c5bd36e07a1373745e_externalid string = '/subscriptions/73e331b8-28c4-4be6-b9ab-a4eb4b1ee42e/resourceGroups/storage-acc-RG/providers/Microsoft.Compute/disks/machine-strorage-test_OsDisk_1_4c4ea6a621b743c5bd36e07a1373745e'
param networkInterfaces_machine_strorage_test344_externalid string = '/subscriptions/73e331b8-28c4-4be6-b9ab-a4eb4b1ee42e/resourceGroups/storage-acc-RG/providers/Microsoft.Network/networkInterfaces/machine-strorage-test344'

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
          id: disks_machine_strorage_test_OsDisk_1_4c4ea6a621b743c5bd36e07a1373745e_externalid
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
          id: networkInterfaces_machine_strorage_test344_externalid
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
