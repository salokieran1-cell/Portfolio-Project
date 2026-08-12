param location string = 'southafricanorth'
param vmName string = 'vm-web02'
param adminUsername string = 'azureuser'
@secure()
param adminPassword string
param myIpAddress string
param vmSize string = 'Standard_B2ats_v2'

// Network Security Group
resource nsg 'Microsoft.Network/networkSecurityGroups@2023-09-01' = {
  name: 'nsg-${vmName}'
  location: location
  properties: {
    securityRules: [
      {
        name: 'AllowSSHFromMyIP'
        properties: {
          priority: 100
          direction: 'Inbound'
          access: 'Allow'
          protocol: 'Tcp'
          sourceAddressPrefix: '${myIpAddress}/32'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '22'
        }
      }
      {
        name: 'DenyAllInbound'
        properties: {
          priority: 4096
          direction: 'Inbound'
          access: 'Deny'
          protocol: '*'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '*'
        }
      }
    ]
  }
}

// Virtual Network + Subnet
resource vnet 'Microsoft.Network/virtualNetworks@2023-09-01' = {
  name: '${vmName}VNET'
  location: location
  properties: {
    addressSpace: { addressPrefixes: ['10.0.0.0/16'] }
    subnets: [
      {
        name: '${vmName}Subnet'
        properties: {
          addressPrefix: '10.0.0.0/24'
          networkSecurityGroup: { id: nsg.id }
        }
      }
    ]
  }
}

// Public IP
resource pip 'Microsoft.Network/publicIPAddresses@2023-09-01' = {
  name: '${vmName}PublicIP'
  location: location
  properties: { publicIPAllocationMethod: 'Static' }
  sku: { name: 'Standard' }
}

// Network Interface
resource nic 'Microsoft.Network/networkInterfaces@2023-09-01' = {
  name: '${vmName}Nic'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: { id: vnet.properties.subnets[0].id }
          publicIPAddress: { id: pip.id }
          privateIPAllocationMethod: 'Dynamic'
        }
      }
    ]
  }
}

// Virtual Machine
resource vm 'Microsoft.Compute/virtualMachines@2023-09-01' = {
  name: vmName
  location: location
  properties: {
    hardwareProfile: { vmSize: vmSize }
    osProfile: {
      computerName: vmName
      adminUsername: adminUsername
      adminPassword: adminPassword
    }
    storageProfile: {
      imageReference: {
        publisher: 'Canonical'
        offer: '0001-com-ubuntu-server-jammy'
        sku: '22_04-lts'
        version: 'latest'
      }
      osDisk: { createOption: 'FromImage' }
    }
    networkProfile: {
      networkInterfaces: [ { id: nic.id } ]
    }
  }
}

output vmPublicIP string = pip.properties.ipAddress
