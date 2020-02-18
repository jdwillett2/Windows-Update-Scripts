$serverinput = Read-Host "Server Name"
$file = Read-Host "Update List File Name"
$server = Get-WsusServer -Name $serverinput -PortNumber 80
foreach ($i in (get-content $file))
{
    $update = get-WsusUpdate -UpdateServer $server -UpdateId $i
    Approve-WsusUpdate -Action Install -Update $update -TargetGroupName "All Computers" -Verbose
}