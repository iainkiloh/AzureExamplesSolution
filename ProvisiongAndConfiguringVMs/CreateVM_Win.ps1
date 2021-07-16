Connect-AzAccount -SubscriptionId "BLAH" -UseDeviceAuthentication

Set-AzContext -SubscriptionId "BLAH"

New-AzResourceGroup -Name "KilohAzureLessons1_RG" -Location "UK South"

#Create credential to use during the VM Creation
$username = 'SOMEADMINUSERNAME'
$password = ConvertTo-SecureString 'SOMEADMINPASSWORD' -AsPlainText -Force
$WindowsCred = New-Object System.Management.Automation.PSCredential ($username, $password) 

#Create the VM
New-AzVM `
    -ResourceGroupName 'KilohAzureLessons1_RG' `
    -Name 'psdemo-win-vm' `
    -Image 'Win2019DataCenter' `
    -Location 'UK South' `
    -Credential $WindowsCred `
    -OpenPorts 3389

#Get the public ip address
Get-AzPublicIpAddress `
    -ResourceGroupName 'KilohAzureLessons1_RG' `
    -Name 'psdemo-win-vm' | Select-Object IpAddress 

    







