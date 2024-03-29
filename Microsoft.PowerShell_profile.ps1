## ┌─────────────────────────────────────Tools─────────────────────────────────────┐
## | la       List Aliases                 |   cm        Install Content Manager   |
## | dame     Reset Dameware               |   O365      Check Exchange Licenses   |
## | ad       Compare AD Groups            |   ADGroup   Export AD Group Members   |
## | sw       Install Software             |                                       |
## | zbat     New Z Drive Batch File       |                                       |
## | rfix     Registry Fixes               |                                       |
## | psb      PowerShell Backup            |                                       |
## | gpolicy  Remote GPUpdate /Force       |                                       |
## └───────────────────────────────────────*───────────────────────────────────────┘


[System.Collections.Generic.List[scriptblock]]$Global:Prompt = @(
# Right Aligned
{ " " * ($Host.UI.RawUI.BufferSize.Width - 29) }
{ "$F;${er}m{0}" -f $([char]0x25c4) }
{ "$F;15m$B;${er}m{0}" -f $(if (@(get-history).Count -gt 0){(Get-History)[-1] | % { "{0:c}" -f (New-TimeSpan $_.StartExecutionTime $_.EndExecutionTime)}}else{'00:00:00:0000000'})}

{ "$F;7m$B;${er}m{0}" -f $([char]0x25c4) }
{ "$F;0m$B;7m{0}" -f $(Get-Date -Format "hh:mm:ss tt") }

# Left Aligned
{ "$F;15m$B;160m{0}" -f $('{0:d4}' -f $MyInvocation.HistoryId) }
{ "$F;160m$B;2m{0}" -f $([char]0x25ba) }

{ "$B;2m$F;15m{0}" -f $($pwd.Drive.Name) }
{ "$B;20m$F;2m{0}" -f $([char]0x25ba) }

{ "$B;20m$F;14m{0}$E[0m" -f $(Split-Path $PWD -Leaf) }
{ "$F;20m{0}$E[0m" -f $([char]0x25ba) }
)

# Prompt Function
function global:prompt {
$global:er = if ($?){22}else{1}
$E = "$([char]27)"
$F = "$E[38;5"
$B = "$E[48;5"
-join $Global:Prompt.Invoke()
} 

# List Aliases Function
Function la {
(Select-String -Path $PROFILE -Pattern '##' -exclude 'Select-String').Line.TrimStart(" ", "#") | Select-String -Pattern 'Select-String' -NotMatch
}

# Set Aliases
$o365path = <PATH HERE>
$adgrouppath = <PATH HERE>
Set-Alias dame Reset-Dameware
Set-Alias ad Compare-ADGroups
Set-Alias sw Install-Software
Set-Alias zbat New-ZDriveBat
Set-Alias rfix Set-RegFix
Set-Alias gpolicy Remote-GPupdate
Set-Alias cm Install-ContentManager
Set-Alias psb Backup-PS
Set-Alias ls Get-ChildItemColor -option AllScope -Force
Set-Alias dir Get-ChildItemColor -option AllScope -Force
Set-Alias O365 $o365path
Set-Alias ADGroup $adgrouppath


# Set PSReadLineOptions
Set-PSReadLineOption -BellStyle None

# Set Colors
$console = $host.ui.rawui
$console.backgroundcolor = "DarkMagenta"

# Transcribe Daily log
$username = <USERNAME HERE>
$path = "C:\Users\$username\Documents\WindowsPowerShell\Logs"
$date = Get-Date -format "MM_dd_yyyy"
$TranscriptTest = Test-Path "C:\Users\$username\Documents\WindowsPowerShell\Logs\PS_$date.txt"
$TranscriptFile = "C:\Users\$username\Documents\WindowsPowerShell\Logs\PS_$date.txt"
IF ($TranscriptTest -eq $True) {
Start-Transcript -Path $TranscriptFile -Append}
ELSE { New-Item -itemtype "file" -path $path -Name PS_$date.txt
Start-Transcript -Path $TranscriptFile -Append}

# Clean up logs older than 30 days
$Daysback = "-30"
$CurrentDate = Get-Date
$DeleteDate = $CurrentDate.AddDays($Daysback)
Get-ChildItem $Path | Where-Object { $_.LastWriteTime -lt $DeleteDate } | Remove-Item

# Set Starting Prompt Location
Set-Location c:\
