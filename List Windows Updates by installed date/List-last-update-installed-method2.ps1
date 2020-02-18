#Comment out the following two lines to run on single host, otherwise input file is required.
#$input = Read-Host "Enter Input File"
#$a = get-content $input
#Uncommend the following line if running on single host
$a = Read-Host "ComputerName"

$a | foreach {Get-WmiObject -ComputerName $_ -class win32_reliabilityRecords| where  SourceName -EQ "Microsoft-Windows-WindowsUpdateClient” |select @{LABEL = “date”;EXPRESSION = {$_.ConvertToDateTime($_.timegenerated)}},
user, productname }
