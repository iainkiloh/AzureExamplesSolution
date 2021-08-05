#https://slstudentpublic.blob.core.windows.net/operations/PowerShell%20Guide_Skylines%20Academy_AZ.pdf

Connect-AzAccount -SubscriptionId "BLAH" -UseDeviceAuthentication

Set-AzContext -SubscriptionId "BLAH"

Get-AzContext

New-AzResourceGroup -Name "KilohDemoRG" -Location "UK South"

#Create credential to use during the VM Creation
$username = 'Admin345!'
$password = ConvertTo-SecureString '4dmin345!' -AsPlainText -Force
$WindowsCred = New-Object System.Management.Automation.PSCredential ($username, $password) 

#Create the VM
New-AzVM `
    -ResourceGroupName 'KilohDemoRG' `
    -Name 'psdemo-win-vm' `
    -Image 'Win2019DataCenter' `
    -Location 'UK South' `
    -Credential $WindowsCred `
    -OpenPorts 80,3389

#Get the public ip address
Get-AzPublicIpAddress `
    -ResourceGroupName 'KilohDemoRG' `
    -Name 'psdemo-win-vm' | Select-Object IpAddress 

    
#stop vm
Stop-AzVm -ResourceGroupName 'KilohDemoRG' -Name 'psdemo-win-vm' -Force

#deallocate vm


#delete vm
Remove-AzVm -ResourceGroupName 'KilohDemoRG' -Name 'psdemo-win-vm'

#delete rg
Remove-AzResourceGroup -Name "KilohDemoRG" -Force


# create image of existing vm using pwsh
#first you need to use sysprep to generalize the image - do this on the vm
#'vars'
$vmName = "dumbassvm"
$rgName = "KilohDemoRG"
$location = "UK South"
$imageName = "dumbassimage"

# ensure vm is stopped / deallocated
Stop-AzVM -ResourceGroupName $rgName -Name $vmName -Force

# set to generalized - note the vm is already generaliuzed using sysprep, this just identifies it as such is azure
Set-AzVm -ResourceGroupName $rgName -Name $vmName -Generalized

$vm = Get-AzVM -Name $vmName -ResourceGroupName $rgName

$image = New-AzImageConfig -Location $location -SourceVirtualMachineId $vm.Id 

New-AzImage -Image $image -ImageName $imageName -ResourceGroupName $rgName

# create new vm from the image using the New-AzVm command
$username = 'Admin345!'
$password = ConvertTo-SecureString '4dmin345!' -AsPlainText -Force
$WindowsCred = New-Object System.Management.Automation.PSCredential ($username, $password) 

New-AzVm -ResourceGroupName $rgName -Name "vmfromimage" -ImageName $imageName -Location $location -OpenPorts 3389 -Credential $WindowsCred


Remove-AzResourceGroup -Name "KilohDemoRG" -Force




