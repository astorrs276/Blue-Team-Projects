#!/bin/bash

if [ "$EUID" -ne 0 ]; then
  echo "Please run as root (sudo)."
  exit 1
fi

# FTP files
cp -r /srv/ftp/ftpuser/files/* /backups/ftp/

# Binaries
cp /usr/bin/whoami /backups/binaries/whoami
