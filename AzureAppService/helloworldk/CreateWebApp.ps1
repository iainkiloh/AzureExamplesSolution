
$webappname = "helloworlk$(Get-Random)"
$rgname = 'kiloh-webapps-RG'
$location = 'uksouth'


#New-AzResourceGroup -Name $rgname -Location $location

#New-AzAppServicePlan -Name $webappname -Location $location -ResourceGroupName $rgname -Tier S1

New-AzWebApp -ResourceGroupName "Kiloh-webapps-RG" -Name "kilohnothingapp12987" -Location "UK South" -AppServicePlan "kilohnothingapp12987_SrvPlan"





