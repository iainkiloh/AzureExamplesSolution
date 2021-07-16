# https://docs.microsoft.com/en-us/powershell/module/az.cosmosdb/new-azcosmosdbaccount?view=azps-6.1.0
# note -whatif is available for all these to show what would happen if ran
# New-AzCosmosDBAccount
New-AzCosmosDBAccount -ResourceGroupName mycoolCosmos -Name mycool-cosmos-account -Location "UK South" -EnableMultipleWriteLocations -ApiKind Sql

# Update-AzCosmosDBAccount
# Cannot update Account Regions simulataneously with other properties.
# Cannot update -EnableMultipleWriteLocations simulataneously with other properties.
Update-AzCosmosDBAccount -ResourceGroupName mycoolCosmos -Name mycool-cosmos-account -DefaultConsistencyLevel "Eventual"

Update-AzCosmosDBAccount -ResourceGroupName mycoolCosmos -Name mycool-cosmos-account -EnableMultipleWriteLocations 1

#Update-AzCosmosDBAccountFailoverPriority -ResourceGroupName rg -Name dbname -FailoverPolicy "region1, region2, region3"
#Update-AzCosmosDBAccountRegion -ResourceGroupName rg1 -Name dbname -Location "location1, location2"  -only supports additions

# Get-AzCosmosDBAccount
Get-AzCosmosDBAccount -ResourceGroupName mycoolCosmos
Get-AzCosmosDBAccount -ResourceGroupName mycoolCosmos -Name mycool-cosmos-account

#Remove-AzCosmosDBAccount
Remove-AzCosmosDBAccount -ResourceGroupName mycoolCosmos -Name mycool-cosmos-account -whatif 

#New-AzCosmosDBSqlDatabase
New-AzCosmosDBSqlDatabase -AccountName mycool-cosmos-account -Name GamingPlatform -ResourceGroupName mycoolCosmos
# can specify Throughput and AutoscaleMaxThroughput if desired - default throuhput is 400

# Get-AzCosmosDBSqlDatabase
Get-AzCosmosDBSqlDatabase -ResourceGroupName mycoolCosmos -AccountName mycool-cosmos-account 
Get-AzCosmosDBSqlDatabase -ResourceGroupName mycoolCosmos -AccountName mycool-cosmos-account -Name GamingPlatform
Get-AzCosmosDBSqlDatabase -ResourceGroupName mycoolCosmos -AccountName mycool-cosmos-account -Name GamingPlatform | Select-Object Name,Location,Id

# Update-AzCosmosDBSqlDatabase
#Update-AzCosmosDBSqlDatabase -ResourceGroupName mycoolCosmos -AccountName mycool-cosmos-account -Name GamingPlatform  [-Throughput <Int32>]
#[-AutoscaleMaxThroughput <Int32>]

Remove-AzCosmosDBSqlDatabase -Name GamingPlatform -ResourceGroupName mycoolCosmos -AccountName mycool-cosmos-account -whatif 

# container usage
New-AzCosmosDBSqlContainer -ResourceGroupName mycoolCosmos -AccountName mycool-cosmos-account -DatabaseName GamingPlatform -Name Profiles -Throughput 400 -PartitionKeyPath "/profileId" -PartitionKeyKind "Hash"
# https://docs.microsoft.com/en-us/powershell/module/az.cosmosdb/update-azcosmosdbsqlcontainer?view=azps-6.1.0
Update-AzCosmosDbSqlContainer -ResourceGroupName mycoolCosmos -AccountName mycool-cosmos-account -DatabaseName GamingPlatform -Name Profiles -Throughput 500

Remove-AzCosmosDBSqlContainer -ResourceGroupName mycoolCosmos -AccountName mycool-cosmos-account -DatabaseName GamingPlatform -Name Profiles





















