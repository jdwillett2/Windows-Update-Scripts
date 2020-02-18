Param([parameter(Mandatory = $true, ValueFromPipeline = $true)]$Server)

Process {
	
        if (Test-Connection -ComputerName $server -count 1 -quiet) {
            write-host "$server is online, connecting..." -BackgroundColor Yellow -ForegroundColor Black
            copy-item -Path .\wsusadd_turnon.bat -Destination \\$server\c$
            psexec.exe -s \\$server c:\wsusadd_turnon.bat 2> $null
            Remove-Item -Path \\$server\c$\wsusadd_turnon.bat
            }
        else {
            write-host "$server is not online" -BackgroundColor Red -ForegroundColor White
            }
}
