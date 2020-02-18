Param([parameter(Mandatory = $true, ValueFromPipeline = $true)]$Server)

Process {
	
        if (Test-Connection -ComputerName $server -count 1 -quiet) {
            write-host "$server is online, connecting..." -BackgroundColor Yellow -ForegroundColor Black
            copy-item -Path .\wsusadd_turnon.ps1 -Destination \\$server\c$
            psexec.exe -s \\$server cmd /c "powershell -noninteractive -file C:\wsusadd_turnon.ps1"
            Remove-Item -Path \\$server\c$\wsusadd_turnon.ps1
            }
        else {
            write-host "$server is not online" -BackgroundColor Red -ForegroundColor White
            }
}
