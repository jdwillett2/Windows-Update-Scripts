<#
.SYNOPSIS

This script will three reports from WSUS for the computers that have a status of Failed, NotInstalled, and Unknown.  It then uploads these reports to the team Sharepoint site, and archives the old one in an archive folder on the site.
Reports older than 7 days are deleted from the archive.

.DESCRIPTION

The script first runs the three reports and dumps them in a temp directory on the server.  It then maps a drive to the IU Health Service Delivery Sharepoint site, and moves the previous days reports into the "ReportArchive" folder on the site.
Next, it deletes anything in the archive folder older than 7 days, and finally uploads the new reports to the site (one level up from the Archive folder, or in the WSUS folder).  It cleans up by deleting the reports off the server where they 
were created, and removing it's drive mapping to not clog things up.  There is currently no input required in the script as it is designed to be run on a schedule every day the same exact way.  All parameters are hard-coded.
This could, of course, easily be changed if needed.

.NOTES

File Name: Report-Upload-Sharepoint.ps1
Author: Jesse Willett
Created on 8/29/2017
Requires PoshWSUS modules to be installed on the computer running the script:  https://github.com/proxb/PoshWSUS

.EXAMPLE

.\Report-Upload-Sharepoint.ps1

There are no parameters and no inputs.

#>

#Declare variables. $daysback is the amount of days it counts back when deleting old reports.  $dateplain is obviously just the date, and $date is the date converted to a suitable format to append to file names.  
#$datetodelete is the calculated date off of $daysback.
$daysback = "-7"
$dateplain = Get-Date
$date = Get-Date -Format MM-dd-yyyy
$datetodelete = $dateplain.AddDays($daysback)

#Connect to the appropriate WSUS server.  Probably not necessary when locally run, but I'm leaving it in.
Connect-PSWSUSServer -WsusServer ICWWSUSAPVG -SecureConnection:$true -Port 8531

#These three lines pull the actual reports and save them in C:\ReportScript\Upload.
Get-PSWSUSClient -IncludedInstallationState Failed -IncludeDownstreamComputerTargets | select FullDomainName, RequestedTargetGroupName, IPAddress, LastSyncTime, LastReportedStatusTime | export-csv D:\WSUS\Upload\Failed_$date.csv -Force
Get-PSWSUSClient -IncludedInstallationState NotInstalled -IncludeDownstreamComputerTargets | select FullDomainName, RequestedTargetGroupName, IPAddress, LastSyncTime, LastReportedStatusTime | export-csv D:\WSUS\Upload\NotInstalled_$date.csv -Force
Get-PSWSUSClient -IncludedInstallationState Unknown -IncludeDownstreamComputerTargets | select FullDomainName, RequestedTargetGroupName, IPAddress, LastSyncTime, LastReportedStatusTime | export-csv D:\WSUS\Upload\Unknown_$date.csv -Force

#Map Y drive to Sharepoint
net use Y: "https://iuhealth.sharepoint.com/sites/Service_Delivery/Shared%20Documents"

#Copy yesterdays reports into the archive folder on Sharepoint
Copy-Item -Path "Y:\WSUS\Failed*.csv" -Destination "Y:\WSUS\ReportArchive"
Copy-Item -Path "Y:\WSUS\NotInstalled*.csv" -Destination "Y:\WSUS\ReportArchive"
Copy-Item -Path "Y:\WSUS\Unknown*.csv" -Destination "Y:\WSUS\ReportArchive"
Remove-Item Y:\WSUS\Failed*.csv
Remove-Item Y:\WSUS\NotInstalled*.csv
Remove-Item Y:\WSUS\Unknown*.csv

#This line deletes reports in the archive folder older than 7 days
Get-ChildItem Y:\WSUS\ReportArchive | Where-Object { $_.LastWriteTime -lt $datetodelete } | Remove-Item

#This copies the new reports into the WSUS folder
Copy-Item D:\WSUS\Upload\*.* Y:\WSUS\ -Force

#Cleaning up the drive mapping and deleting local copies of the reports
net use Y: /delete
Remove-Item D:\WSUS\Upload\*.*