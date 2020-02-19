$citrix = Read-Host "Is it a Citrix Group? (Y/N)"
$group = Read-Host "Enter Security Group Name"

If ($citrix -eq "Y") {
    get-adgroupmember -Identity "Citrix OU DN HERE" | Select -Exp Name | & '.\WSUSAdd-Process-Parallel.ps1'}
Else {
    get-adgroupmember -Identity "OU DN HERE" | Select -Exp Name | & '.\WSUSAdd-Process-Parallel.ps1'}
