#Looks for updates installed beyond a certain date defined by user input
#Written by Jesse Willett 11/5/2014

$Month = Read-Host "Enter a month"
$Day = Read-Host "Enter a day"
$Year = Read-Host "Enter a year"
$Computer = Read-Host "Enter a computer name"

$Dayfixed = $Day-1

$Date = "$Month/$DayFixed/$Year"

echo $Date

get-hotfix -computername $Computer | where { $_.InstalledOn -gt "$date"} | Export-Csv Results.csv

Invoke-Item Results.csv