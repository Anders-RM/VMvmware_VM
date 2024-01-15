# Import VMware PowerCLI module
Import-Module VMware.PowerCLI

# Connect to the VMware vCenter Server
$vcServer = Read-Host "Enter vCenter Server"
Connect-VIServer $vcServer

# Prompt the user for the virtual machine name
$vmName = Read-Host "Enter the virtual machine name"

# Define other variables for the virtual machine
$vmMemoryGB = 4
$vmCPUCount = 2
$datastoreName = Read-Host "Enter the datastore name"
$vmdkSizeGB = 127
$vmFolder = Read-Host "Enter the VM folder path"
$vmCluster = Read-Host "Enter the cluster name"
$vmNetworkName = Read-Host "Enter the network name"

# Prompt the user for the ISO file location
$isoPath = Read-Host "Enter the path to the ISO file"

# Create a new virtual machine with the specified settings
New-VM -Name $vmName -MemoryGB $vmMemoryGB -NumCpu $vmCPUCount -Datastore $datastoreName -DiskGB $vmdkSizeGB -Location $vmFolder -Cluster $vmCluster

# Get the newly created VM object
$vm = Get-VM -Name $vmName

# Add a network adapter to the virtual machine
New-NetworkAdapter -VM $vm -NetworkName $vmNetworkName -Type VMXNET3

# Add a CD/DVD drive to the virtual machine and attach the ISO
New-CDDrive -VM $vm -ISOPath $isoPath -StartConnected:$true

# Start the virtual machine
Start-VM -VM $vm

# Disconnect from the vCenter Server
Disconnect-VIServer -Server $vcServer -Confirm:$false