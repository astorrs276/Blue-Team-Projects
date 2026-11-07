#!/bin/bash
echo "Removing all SSH authorized_keys files and dissabeling root SSH"


find /home /root -name "authorized_keys" -type f -exec bash -c '> "{}" && echo "Cleared {}"' \;


sed -i 's/^#*PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config


systemctl restart sshd || systemctl restart ssh || service ssh restart

echo "Done"
