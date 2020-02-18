Param([parameter(Mandatory = $true, ValueFromPipeline = $true)]$server)

Process {
	start-process "$pshome\powershell.exe" -argumentlist "-command .\WSUSAdd-Pipe-Parallel-TurnOn.ps1 $server"
}