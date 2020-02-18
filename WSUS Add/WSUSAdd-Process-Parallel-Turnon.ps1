Param([parameter(Mandatory = $true, ValueFromPipeline = $true)]$server)

Process {
	start-process "$pshome\powershell.exe" -argumentlist "-command .\WSUSAdd-Pipe-Parallel-turnon-ps.ps1 $server"
}