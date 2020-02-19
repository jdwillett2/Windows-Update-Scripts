#Lists last update installed on the specified list of comupters.
#Written by Jesse Willett 11/5/2014

$input = Read-Host "Enter Input File"

$a = get-content $input

$a | foreach {(get-hotfix -computername $_ | sort installedon)[-1] | select PSComputerName, InstalledOn | Export-Csv Results.csv -Append}
