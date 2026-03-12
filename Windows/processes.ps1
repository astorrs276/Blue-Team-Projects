# Loop until the user quits
while ($true) {
    $keyword = Read-Host "Keyword to search for (blank to quit): "

    # Check if the user entered a keyword to search for and quit if not
    if ([string]::IsNullOrWhiteSpace($keyword)) {
        Write-Host "Exiting"
        continue
    }

    # Get matching processes
    $matches = Get-Process | Where-Object {
        $_.ProcessName -match $keyword
    }

    # Continues if no matching processes are found
    if (-not $matches) {
        Write-Host "No matching processes found`n"
        continue
    }

    # Print matching processes
    Write-Host "Matching processes:"
    $matches | Format-Table Id, ProcessName, CPU, StartTime -AutoSize
    Write-Host ""

    # Input PIDs to kill
    $pids = Read-Host "Enter PID(s) to kill (separated by spaces), or press Enter for none: "

    if (-not [string]::IsNullOrWhiteSpace($pids)) {
        foreach ($pid in $pids -split "\s+") {
            if ($pid -match '^[0-9]+$') {
                try {
                    Stop-Process -Id $pid -ErrorAction Stop
                    Write-Host "Killed PID $pid"
                }
                catch {
                    Write-Host "Failed to kill PID $pid"
                }
            }
            else {
                Write-Host "Invalid PID: $pid"
            }
        }
        Write-Host ""
    }
}