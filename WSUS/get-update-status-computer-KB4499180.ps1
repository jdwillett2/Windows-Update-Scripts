1 <#Define HTML Body,table, cells
 2 $a = "<style>"
 3 $a = $a + "BODY{background-color:white;font-family: Arial; font-size: 8pt;}"
 4 $a = $a + "TABLE{border-width: 1px;border-style: solid;border-color: black;border-collapse: collapse;table-layout: fixed; width: 100%;}"
 5 $a = $a + "TH{border-width: 1px;padding: 0px;border-style: solid;border-color: black;background-color:white;}"
 6 $a = $a + "TD{border-width: 1px;padding: 0px;border-style: solid;border-color: black;background-color:white;}"
 7 $a = $a + "</style>"
 8 $a = $a + "<p style="+'"font-family: Arial;font-size: 10pt;"'+">Table Summary WSUS</p><p style="+'"font-family: Arial; font-size: 10pt;"'+">Admin</p>"
 9 #>
 
#Sent to admin
$to = "EMAIL HERE"

#Now Import Posh modul and connect to server
Import-module poshwsus
Connect-PSWSUSServer -WsusServer WSUSSERVER -port 8531 -SecureConnection:$true -verbose

 
<#
So, PoshWSUS has couple of scripts, and I foud out I need two, and I need them to combined
Get-PoshWSUSUpdateSummaryPerClient
and
Get-PoshWSUSClient
First I get status by computer, then mor information about client itself
#>
 
 
$Output = @() #define array to fill
$server = Get-WsusServer -Name $WSUSSERVER -PortNumber 8531 -UseSsl
$Computers = Get-WsusComputer -UpdateServer $server -IncludeDownstreamComputerTargets
 
foreach ($Computer in $Computers)
     {
    $scope = New-PSWSUSComputerScope -IncludeDownstreamComputerTargets:$true -NameIncludes $Computer.FullDomainName
    $uscope = New-PSWSUSUpdateScope -ApprovedStates LatestRevisionApproved -TextIncludes "KB4499180"
    $computersOstalo = Get-PSWSUSUpdateSummaryPerClient -ComputerScope $scope -UpdateScope $uscope | select *
    $grupaOstalo = Get-PSWSUSGroup

#save fields in array
        $Props = @{
      "ComputerName" = $Computer.FullDomainName
            "IPAddress" = $Computer.IPAddress
            "OS" = $Computer.OSDescription
            "Group" = $Computer.RequestedTargetGroupName
      "LastUpdated" = $computersOstalo.LastUpdated
      "LastSyncTime" = $Computer.LastSyncTime
      "LastReportedStatusTime" = $Computer.LastReportedStatusTime
            "InstalledCount" = $computersOstalo.InstalledCount
            "NotInstalledCount" = $computersOstalo.NotInstalledCount
            "InstalledPendingReboot" = $computersOstalo.InstalledPendingRebootCount
            "Downloaded" = $computersOstalo.DownloadedCount
            "FailedCount" = $computersOstalo.FailedCount
            "UnknownCount" = $computersOstalo.UnknownCount
            "NeededCount" = $computersOstalo.NeededCount
            
                        }
   #Save every record to @output array
    $Output += New-Object PSObject -Property $Props 
    }

# convert records to HTML
$body = $output |Select-Object Group,ComputerName,IPAddress,OS,InstalledCount,NotInstalledCount,InstalledPendingReboot,Downloaded,FailedCount,UnknownCount,NeededCount,LastUpdated,LastSyncTime,LastReportedStatusTime | Export-Csv .\ComputerStatus_KB4499180.csv
 
#$body = $body |ConvertTo-HTML -head $a |Out-String

 
#and finayl send mail to admin
#send-mailmessage -from "isipt@iuhealth.org" -to $to -subject "Report Server Summary" -bodyAsHtml -body $Body  -priority Normal -smtpServer "smtp1.iuhealth.org"
