Param([parameter(Mandatory = $true, ValueFromPipeline = $true)]$Server)

Process {
	
        if (Test-Connection -ComputerName $server -count 1 -quiet) {
            write-host "$server is online, connecting..." -BackgroundColor Yellow -ForegroundColor Black
            Invoke-Command -ComputerName $Server -ScriptBlock 
                {
                klist.exe -li 0x3e7 purge
                gpupdate.exe /force 
                set-service -Name wuauserv -StartupType Automatic -Verbose
                Stop-Service -Name wuauserv -Verbose
                Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate" -Name "PingID" -Force -Verbose
                Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate" -Name "AccountDomainSid" -Force -Verbose
                Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate" -Name "SusClientID" -Force -Verbose
                Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate" -Name "SusClientIDValidation" -Force -Verbose
                Start-Service -Name wuauserv -Verbose
                wuauclt.exe /resetauthorization -
                wuauclt.exe /detectnow
                wuauclt.exe /reportnow
                $AutoUpdates = New-Object -ComObject "Microsoft.Update.AutoUpdate"
                $AutoUpdates.DetectNow()
                }
            }
        else {
            write-host "$server is not online" -BackgroundColor Red -ForegroundColor White
            }
}
