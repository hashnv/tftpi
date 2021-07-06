#!/bin/bash

set -ex

start() {
  # Update package repositories
  sudo apt update
  # Install tftp server daemon
  sudo apt install tftpd-hpa
  # Overwrite existing tftp configuration
  sudo echo '# /etc/default/tftpd-hpa
TFTP_USERNAME="tftp"
TFTP_DIRECTORY="/tftp"
TFTP_ADDRESS="0.0.0.0:69"
TFTP_OPTIONS="--secure --create"' > /etc/default/tftpd-hpa
  # Make /tftp directory and set permissions
  sudo mkdir /tftp && sudo chown tftp. /tftp
  # Restart tftpd-hpa and enable on startup
  sudo systemctl restart tftpd-hpa && sudo systemctl enable tftpd-hpa
  # should all be done now!
}

start
