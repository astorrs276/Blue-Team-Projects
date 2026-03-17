#!/bin/bash

# OS/Kernel
echo -e "[OS]"
echo -n "OS Version:"
cat /etc/os-release | grep "PRETTY_NAME" | grep -o "\".*.\"" | tr -d '"'
echo -n "Kernel Version : "
uname -r
echo -n "Hostname: "
hostname

# Admin Users
echo -e "\n[Admins]"
for group in adm sudo wheel; do
    getent group $group;
done

# Users
echo -e "\n[Users]"
getent passwd | cut -d':' -f1,3,7 | grep -Ev "nologin|false"

# IP Addresses
echo -e "\n[IP]"
echo "Route: "
ip -c route | grep "default"
echo
ip -br -c a

# MAC Addresses
echo -e "\n[MAC]"
ip -br -c link

# Ports
echo -e "\n[Ports]"
ss -tulpn | grep -v "127.0.0.*"
