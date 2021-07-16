#Connect-AzAccount -SubscriptionId "blaH" -UseDeviceAuthentication

#Set-AzContext -SubscriptionId "BLAH"

New-AzResourceGroup -Name "KilohAzureLessons1_RG" -Location "UK South"

$resourceGroupName = "KilohAzureLessons1_RG"
$location = "UK South"

# Create a subnet configuration
$subnetConfig = New-AzVirtualNetworkSubnetConfig `
  -Name "kdemosubnet" `
  -AddressPrefix 192.168.1.0/24

# Create a virtual network
$vnet = New-AzVirtualNetwork `
  -ResourceGroupName $resourceGroupName `
  -Location $location `
  -Name "kdemoVNET" `
  -AddressPrefix 192.168.0.0/16 `
  -Subnet $subnetConfig

# Create a public IP address and specify a DNS name
$pip = New-AzPublicIpAddress `
  -ResourceGroupName $resourceGroupName `
  -Location $location `
  -AllocationMethod Static `
  -IdleTimeoutInMinutes 4 `
  -Name "kdemopublicdns$(Get-Random)"

# Create an inbound network security group rule for port 22
$nsgRuleSSH = New-AzNetworkSecurityRuleConfig `
  -Name "kdemoNSGRuleSSH"  `
  -Protocol "Tcp" `
  -Direction "Inbound" `
  -Priority 1000 `
  -SourceAddressPrefix * `
  -SourcePortRange * `
  -DestinationAddressPrefix * `
  -DestinationPortRange 22 `
  -Access "Allow"

$nsg = New-AzNetworkSecurityGroup `
  -ResourceGroupName $resourceGroupName `
  -Location $location `
  -Name "kdemoNSG" `
  -SecurityRules $nsgRuleSSH

# Create a virtual network card and associate with public IP address and NSG
$nic = New-AzNetworkInterface `
  -Name "kdemoNic" `
  -ResourceGroupName $resourceGroupName `
  -Location $location `
  -SubnetId $vnet.Subnets[0].Id `
  -PublicIpAddressId $pip.Id `
  -NetworkSecurityGroupId $nsg.Id

# Define a credential object
$securePassword = ConvertTo-SecureString ' ' -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ("SOMEADMINUSERNAMEn", $securePassword)
$sshPublicKey = cat ~/.ssh/testingkey.pub

# Create a virtual machine configuration
$vmConfig = New-AzVMConfig `
  -VMName "psdemo-lin1" `
  -VMSize "Standard_B1ls" | `
Set-AzVMOperatingSystem `
  -Linux `
  -ComputerName "psdemo-lin1" `
  -Credential $cred `
  -DisablePasswordAuthentication | `
Set-AzVMSourceImage `
  -PublisherName "Canonical" `
  -Offer "UbuntuServer" `
  -Skus "18.04-LTS" `
  -Version "latest" | `
  Add-AzVMNetworkInterface `
    -Id $nic.Id

Add-AzVMSshPublicKey `
  -VM $vmConfig `
  -KeyData $sshPublicKey `
  -Path "/home/SOMEADMINUSERNAME/.ssh/authorized_keys"

New-AzVM `
    -ResourceGroupName $resourceGroupName `
    -Location $location `
    -VM $vmConfig

#Get the public ip address
Get-AzPublicIpAddress `
    -ResourceGroupName $resourceGroupName `
    -Name 'psdemo-lin1' | Select-Object IpAddress 