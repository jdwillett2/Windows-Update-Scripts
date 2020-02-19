$citrix = Read-Host "Is it a Citrix Group? (Y/N)"
$group = Read-Host "Enter Security Group Name"

If ($citrix -eq "Y") {
    get-adgroupmember -Identity "$citrix OU DN Here" | Select -Exp Name | & '.\WSUSAdd-Process-Parallel-Turnon.ps1'}
Else {
    get-adgroupmember -Identity "$group DN HERE" | Select -Exp Name | & '.\WSUSAdd-Process-Parallel-Turnon.ps1'}
