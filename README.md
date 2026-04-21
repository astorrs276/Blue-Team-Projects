# Blue-Team-Projects
A bunch of scripts I've made that can be used by blue teams in competitions

## Tested Scripts
None so far (I need good access to VMs)

## Untested Scripts
### Windows
- display_registries.ps1
  - Displays all values in a user specified registry key. Loops until quit by the user.
- inventory.ps1
  - Displays a list of information about the operating system that is typically asked for in an inventory inject. Includes things like OS version, IP and MAC addresses, all users, etc.
- list_autoruns.ps1
  - Lists all autoruns in typical locations on the device.
- processes.ps1
  - Lists all currently running processes and allows the user to specificy ones to kill.
- users_and_passwords.ps1
  - Lists all users and allows the user to delete them or change their passwords.

### Linux
- inventory.sh
  - Displays a list of information about the operating system that is typically asked for in an inventory inject. Includes things like OS version, IP and MAC addresses, all users, etc.
- list_autoruns.sh
  - Lists all autoruns in typical locations on the device.
- processes.sh
  - Lists all currently running processes and allows the user to specificy ones to kill.
- users_and_passwords.sh
  - Lists all users and allows the user to delete them or change their passwords.

## Scripts to Write
- \[Windows\] Automatically download and rename specific tools (a lot from sysinternals like autoruns and procmon, Everything, etc.)
- \[Linux\] Automatically try to remove and reinstall a lot of standard packages that red team may have tampered with (git, curl, etc.)
- \[Both\] Remove malicious SSH keys (often all of them lol) (should work similar to users_and_passwords)
- \[Both\] Make copies of important files
- \[Both\] Make a user group for the users you need for the comp (then integrate with users_and_passwords)
- \[Both\] Set up firewall rules (varies per comp and the organizer's rules but always important) - things like blocking IPs, blocking ports, and removing remote connections - specifically block basically everything but scored services
- \[Both\] Set up some kind of logging
