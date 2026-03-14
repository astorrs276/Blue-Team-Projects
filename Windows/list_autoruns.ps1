# Print registry autoruns
$paths = @(
    "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run",
    "HKLM:\Software\Microsoft\Windows\CurrentVersion\Run"
    "HKCU:\Software\Microsoft\Windows\CurrentVersion\RunOnce",
    "HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce",
    "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run",
    "HKLM:\Software\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run",
    "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\StartupFolder",
    "HKLM:\Software\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\StartupFolder"
)

foreach ($path in $paths) {
    Write-Host "$path:"
    if (Test-Path $path) {
        $item = Get-ItemProperty -Path $path
        $item.PSObject.Properties |
            Where-Object { $_.MemberType -eq "NoteProperty" } |
            ForEach-Object {
                Write-Host "$($_.Name) -> $($_.Value)"
            }
    } else {
        Write-Host "Registry path not found"
    }
}
Write-Host ""


# Print startup folder contents
$userStartup   = [Environment]::GetFolderPath("Startup")
$systemStartup = [Environment]::GetFolderPath("CommonStartup")

Write-Host "Current User Startup Folder: "
Write-Host $userStartup
Get-ChildItem -Path $userStartup -Force | Select-Object Name, FullName, LastWriteTime
Write-Host ""

Write-Host "System-wide Startup Folder: "
Write-Host $systemStartup
Get-ChildItem -Path $systemStartup -Force | Select-Object Name, FullName, LastWriteTime
Write-Host ""
Write-Host ""


# List task scheduler
Get-ScheduledTask | ForEach-Object {
    $info = Get-ScheduledTaskInfo -TaskName $_.TaskName -TaskPath $_.TaskPath

    [PSCustomObject]@{
        TaskName        = $_.TaskName
        TaskPath        = $_.TaskPath
        State           = $_.State
        LastRunTime     = $info.LastRunTime
        NextRunTime     = $info.NextRunTime
        LastTaskResult  = $info.LastTaskResult
        Author          = $_.Author
        Description     = $_.Description
    }
} | Format-Table -AutoSize
