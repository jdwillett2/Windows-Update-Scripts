Param([parameter(Mandatory = $true, ValueFromPipeline = $true)]$Server)

Process {
	
        if (Test-Connection -ComputerName $server -count 1 -quiet) {
            write-host "$server is online, connecting..." -BackgroundColor Yellow -ForegroundColor Black
            copy-item -Path .\wsusadd.bat -Destination \\$server\c$
            psexec.exe -s \\$server c:\wsusadd.bat 2> $null
            Remove-Item -Path \\$server\c$\wsusadd.bat
            }
        else {
            write-host "$server is not online" -BackgroundColor Red -ForegroundColor White
            }
}
