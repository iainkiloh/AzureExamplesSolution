
#generate a sas token
$context = (Get-AzStorageAccount -ResourceGroupName 'kilohcosmos' -AccountName 'kilogcosmossa').context

#https://docs.microsoft.com/en-us/rest/api/storageservices/create-account-sas?redirectedfrom=MSDN
$sasToken = New-AzStorageAccountSASToken -Context $context -Service Blob -ResourceType Object -Permission rwlau

#local to blob storage
#single file copy
azcopy copy data1.txt "https://kilohcosmossa.blob.core.windows.net/container1/data1.txt${sasToken}" 

# local dir copy  --recurive option uiploads all files in sub dirs also
azcopy copy "C:\Users\IainKiloh\Documents\TestBlobFiles" "https://kilohcosmossa.blob.core.windows.net/container1/${sasToken}" --recursive 
# just all in the dir you specify (NOT sub folder files)
azcopy copy "C:\Users\IainKiloh\Documents\TestBlobFiles\*" "https://kilohcosmossa.blob.core.windows.net/container1/${sasToken}" 
# or specific files with a pattern
azcopy copy "C:\Users\IainKiloh\Documents\TestBlobFiles\*" "https://kilohcosmossa.blob.core.windows.net/container1/${sasToken}" --include-pattern "data*.txt"  


# blob storage to local
$sasToken = New-AzStorageAccountSASToken -Context $context -Service Blob -ResourceType Object,Container -Permission racwdlup
azcopy copy "https://kilohcosmossa.blob.core.windows.net/container1/data1.txt${sasToken}" data4.txt --log-level error 
#rntire dir
azcopy copy "https://kilohcosmossa.blob.core.windows.net/container1/${sasToken}"  "C:\Users\IainKiloh\Documents\TestBlobFiles2" --recursive 

# 1 sa to another sa 
$sasToken2 = New-AzStorageAccountSASToken -Context $storage2Contaxt -Service Blob -ResourceType Object,Container -Permission racwdlup
azcopy copy "https://kilohcosmossa.blob.core.windows.net/container1/TestBlobFiles${sasToken}" "https://kilohstaticweb.blob.core.windows.net/site/TestBlobFiles${sasToken2}" --recursive

