# Blue-Team-Projects
A bunch of scripts I've made that can be used by blue teams in competitions

## Tested Scripts
None so far (I need good access to VMs)

## Untested Scripts
### Windows
display_registries.ps1
inventory.ps1
list_autoruns.ps1
processes.ps1
users_and_passwords.ps1

### Linux
inventory.sh
list_autoruns.sh
processes.sh
users_and_passwords.sh

## Scripts to Write
\[Windows\] Automatically download and rename specific sysinternals tools (autoruns, procmon, not sure what others)
\[Both\] Remove malicious SSH keys (often all of them lol)
\[Both\] Make copies of important files
\[Both\] Make a user group for the users you need for the comp (then integrate with users_and_passwords)
\[Both\] Set up firewall rules (varies per comp and the organizer's rules but always important) - things like blocking IPs, blocking ports, and removing remote connections - specifically block basically everything but scored services
\[Both\] Set up some kind of logging
