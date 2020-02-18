$serverName=Read-Host "Server"
$targetComputerGroup= Read-Host "BaselineGroup"
$checkForMissing=Read-host "MissingGroup1,MissingGroup2"

[void][reflection.assembly]::LoadWithPartialName("Microsoft.UpdateServices.Administration")
$wsus=[Microsoft.UpdateServices.Administration.AdminProxy]::getUpdateServer($serverName,$false)
$computerGroup=$wsus.GetComputerTargetGroups()|ForEach-Object -Process {if ($_.Name -eq $targetComputerGroup) {$_}}
$UpdateScope=New-Object Microsoft.UpdateServices.Administration.UpdateScope
$UpdateScope.ApprovedStates="Any"
$updateScope.ApprovedComputerTargetGroups.Add($computerGroup)
$Approvals = $wsus.GetUpdateApprovals($UpdateScope)

#At this point we have all of the updates assigned to the $targetComputerGroup

$report= @()
write-host "Querying for all Updates approved for $targetComputerGroup"

foreach ($Approval in $approvals) {
   $record=""|Select-Object ComputerGroup,UpdateName, UpdateID
   $record.ComputerGroup=$wsus.GetComputerTargetGroup($Approval.ComputerTargetGroupID).Name
   $record.UpdateName=$wsus.GetUpdate($Approval.UpdateID).Title
   $record.UpdateID=$wsus.GetUpdate($Approval.UpdateID).ID.UpdateID
   $report +=$record
   }

#Now group the results by UpdateName
$GR=$report|group -Property UpdateName

$CheckForMissing=$CheckForMissing.Split(",")

 foreach ($entry in $gr) {
    $groups=@()
    foreach ($g in $entry.Group) {
        $groups += $g.ComputerGroup
        }
    foreach ($missing in $checkForMissing) {
        if ($groups -Contains $missing) {}
        else{
            New-Object PSObject -Property @{
            Name = $entry.Name
            UpdateID = $entry.Group[0].UpdateID
            GroupMissing = $missing
            }
        }
    }
}