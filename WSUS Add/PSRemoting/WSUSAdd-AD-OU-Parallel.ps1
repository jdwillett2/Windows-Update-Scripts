$citrix = Read-Host "Is it a Citrix Group? (Y/N)"
$group = Read-Host "Enter Security Group Name"

If ($citrix -eq "Y") {
    get-adgroupmember -Identity "CN=$group,OU=Citrix Patching Groups,OU=System Update Groups,OU=Server Groups,OU=Servers,OU=Computer Accounts,DC=chp,DC=clarian,DC=org" | Select -Exp Name | & '.\WSUSAdd-Process.ps1'}
Else {
    get-adgroupmember -Identity "CN=$group,OU=System Update Groups,OU=Server Groups,OU=Servers,OU=Computer Accounts,DC=chp,DC=clarian,DC=org" | Select -Exp Name | & '.\WSUSAdd-Process.ps1'}