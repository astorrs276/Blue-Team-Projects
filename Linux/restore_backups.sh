#!/bin/bash

if [ "$EUID" -ne 0 ]; then
  echo "Please run as root (sudo)."
  exit 1
fi

# FTP files
cp -r /backups/ftp/* /srv/ftp/ftpuser/files/

# Binaries
cp /backups/binaries/whoami /usr/bin/whoami
