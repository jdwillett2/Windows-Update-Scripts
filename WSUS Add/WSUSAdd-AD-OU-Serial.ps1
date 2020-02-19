$group = Read-Host "Enter Security Group Name:"

get-adgroupmember -Identity "AD OU DN HERE" | Select -Exp Name | & '.\WSUSAdd-Pipe-Serial.ps1'
