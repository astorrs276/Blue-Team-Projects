# Check if running as Administrator and exit if not
$principal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "users.ps1 run fail"
    exit 1
}

# List of users that will be excluded
$userList = @(
    "whiteteam",
    "datadog"
)

# Get all local users
$users = Get-LocalUser

# Input new password to be used on new accounts
$securePass = Read-Host "Enter new password for '$username'" -AsSecureString

foreach ($user in $users) {
    $username = $user.Name.Trim()

    # Skip system accounts
    if ($user.SID.Value -match "-500$|-501$") {
        continue
    }

    if ($userList -contains $username) {
        Write-Host "'$username' is approved"

        # Skip whiteteam and datadog users
        if ($username -eq "whiteteam" -or $username -eq "datadog") {
            Write-Host "Skipping white team/datadog"
            continue
        }

        # If there's no new password, skip changing passwords
        if (-not $securePass.Length) {
            Write-Host "Skipping password change"
            continue
        }

        # Change the user's password if possible
        try {
            Set-LocalUser -Name $username -Password $securePass
            Write-Host "Password updated for $username."
        }
        catch {
            Write-Host "Password update FAILED for $username."
        }
    } else {
        # If the user isn't in the approved list, ask to delete them and print what happened
        $confirm = Read-Host "Delete user '$username'? [y/n]"
        if ($confirm -eq "y") {
            try {
                Remove-LocalUser -Name $username
                Write-Host "User '$username' removed."
            }
            catch {
                Write-Host "Error removing user '$username'."
            }
        }
        else {
            Write-Host "Did not delete '$username'"
        }
    }
}
