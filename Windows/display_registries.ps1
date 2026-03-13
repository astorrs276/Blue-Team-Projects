# Loops until the user quits
while ($true) {
    $path = Read-Host "Registry path to display (blank to quit): "

    # Check if the user entered a path to display and quit if not
    if ([string]::IsNullOrWhiteSpace($keyword)) {
        Write-Host "Exiting"
        continue
    }

    # Check that the path exists and print everything in it
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