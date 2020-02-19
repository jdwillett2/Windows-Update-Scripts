# Windows-Update-Scripts
 
This is a collection of scripts I have written for various tasks with Windows Update and WSUS.  I'll try and describe them below.

## List Windows Updates by install date

### List-Updates-From-Date.ps1

This script takes input for month, day, year, and computer name and retrieves a list of updates installed since that date.  Output goes to a csv file at the script root.

### List-last-update-installed.ps1

Takes a list of computers from a specified text file and finds the most recently installed update for each computer.  Outputs to a csv file.

### List-last-update-installed-method2.ps1

Same as above basically, it uses WMI instead of the get-hotfix cmdlet to retrieve the information though.  Don't really remember why I had to do it a different way.

## WSUS Add

### PSRemoting folder

Scripts in here do the same thing as all the ones described below, only they use psremoting instead of psexec.

In the next two sections I describe three scripts, which have some dependant scripts that they run.  The end result is each server refreshing it's group membership and cleaning up things on the Windows Update agent in order to properly report to WSUS and have the reboot time configured correctly.

### WSUSAdd-AD-OU-Serial.ps1

Retrieves computers from the specified AD OU, and runs the WSUSAdd-Pipe-Serial.ps1 script on each of them.  

### WSUSAdd-AD-OU-Parallel.ps1 and WSUSAdd-AD-OU-Parallel-Turnon.ps1

These both do the same as above, but for each computer first runs the WSUSAdd-Process-Parallel.ps1 or WSUSAdd-Process-Parallel-Turnon.ps1 scripts which starts a new powershell process, which then runs the WSUSAdd-Pipe-Parallel or WSUSAdd-Pipe-Parallel-turnon.ps1 on each computer. Effectively what this does is opens a new powershell window for each computer in the list so they can all run at once, instead of one at a time like the serial version.  It completes much faster, with the caveat that it can take an enormous amount of CPU and RAM to start all those processes at once when there is a lot of computers.

Difference with the -turnon set of scripts is there is a couple extra commands to make sure the Windows Update service gets turned on if it has been forcefully disabled.

### WSUSAdd-Serial.ps1

Takes a specified list of computers and runs commands on them to refresh security group memberships, and do some Windows Update cleanup for the best possible chance of correctly connecting to WSUS.

### WSUSAdd.bat

The actual batch file which does the work for the first three scripts.

### WSUSAdd-turnon-deletefolder.bat

Runs all the normal commands in the other scripts, but also just entirely nukes the SoftwareDistribution folder to try and get Windows Update working.  I don't have anything set up to run this remotely, I only really use it locally in one off scenarios.

### WUADetect-Server-2016.ps1

Contains the command to initiate a Windows Update detection from the command line on Server 2016 and up, since the old wuauclt commands are deprecated in newer versions of Windows.

##WSUS

### Install Reboot Task

The script in here is designed to be run as a scheduled task locally on a given server.  I use it when I can't get the desired schedule any other way.  The XML file I believe is one I saved from task scheduler.

### Reporting

One script in here, I wrote this to come up with three reports in .csv form and dump them to our team Sharepoint site where everyone can see them.  The three reports are for Failed, NotInstalled, and Unknown status WSUS clients.  Has pretty good comments in the script to learn more.

### Approve-UpdateIDs-from-Pipe-All.ps1

Reads a server name (WSUS server) and a list of updates to be approved and approves them for all computers.

### get-update-approvals-by-group.ps1

Gets the update approvals from WSUS listed by group.  I honestly don't think I wrote this script myself, so I can't say much more than that about it.

### get-update-status-computer.ps1

Retrieves the update status for all computers from WSUS, along with a handful of useful properties about them, and dumps into a .csv file.  I use this for my monthly reports, I put this data into a fancy Excel workbook that makes pretty graphs for management to see.  There are two other versions of this script I had saved specifically for retrieving information about certain KBs.  Same thing just for those single updates.
