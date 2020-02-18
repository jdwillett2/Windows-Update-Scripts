$group = Read-Host "Enter Security Group Name:"

get-adgroupmember -Identity "CN=$group,OU=System Update Groups,OU=Server Groups,OU=Servers,OU=Computer Accounts,DC=chp,DC=clarian,DC=org" | Select -Exp Name | & '.\WSUSAdd-Pipe-Serial.ps1'