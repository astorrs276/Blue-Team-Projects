# OS/Kernel
Write-Host "[OS]"
$os = Get-CimInstance Win32_OperatingSystem
$kernel = Get-CimInstance Win32_OperatingSystem
$hostname = $env:COMPUTERNAME

Write-Host ("OS Version: " + $os.Caption + " " + $os.Version)
Write-Host ("Kernel Version: " + $kernel.BuildNumber)
Write-Host ("Hostname: " + $hostname)

# Admin Users
Write-Host "`n[Admins]"
try {
    Get-LocalGroupMember -Group "Administrators" | Select-Object Name, ObjectClass
} catch {
    Write-Host "Unable to list Administrators group"
}

# Users
Write-Host "`n[Users]"
Get-CimInstance Win32_UserAccount | Where-Object { $_.LocalAccount -eq $true } | Select-Object Name, SID

# IP Addresses
Write-Host "`n[IP]"
Write-Host "Route:"
Get-NetRoute -DestinationPrefix "0.0.0.0/0" | Select-Object DestinationPrefix, NextHop, InterfaceAlias

Write-Host ""
Get-NetIPAddress | Select-Object InterfaceAlias, IPAddress, AddressFamily

# MAC Addresses
Write-Host "`n[MAC]"
Get-NetAdapter | Select-Object Name, MacAddress, Status

# Ports
Write-Host "`n[Ports]"
Get-NetTCPConnection -State Listen | Where-Object { $_.LocalAddress -ne "127.0.0.1" } | Select-Object LocalAddress, LocalPort, OwningProcess

Get-NetUDPEndpoint | Where-Object { $_.LocalAddress -ne "127.0.0.1" } | Select-Object LocalAddress, LocalPort, OwningProcess
