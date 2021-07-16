
New-AzKeyVault -Name "MyKeyVaultname" -Location "UK South" -ResourceGroupName "KilohAzureLessons1_RG"

$Secret = ConvertTo-SecureString -String 'SOMEADMINPASSWORD' -AsPlainText -Force
Set-AzKeyVaultSecret -VaultName 'MyKeyVaultname' -Name 'AdminPassword' -SecretValue $Secret

Set-AzKeyVaultAccessPolicy -VaultName "MyKeyVaultname" -EnabledForTemplateDeployment