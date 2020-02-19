$group = Read-Host "Enter Security Group Name:"

get-adgroupmember -Identity "$group DN HERE" | Select -Exp Name | & '.\WSUSAdd-Pipe-Serial.ps1'
