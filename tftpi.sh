#!/bin/bash

set -ex

start() {
  # Update package repositories
  sudo apt-get update
  # Install USB mount service
  sudo apt-get install usbmount -y
  # Install tftp server daemon
  sudo apt-get install tftpd-hpa -y
  # Add required usbmount configuration
  sudo mkdir -p /etc/systemd/system/systemd-udevd.service.d/
  sudo echo '[Service]
MountFlags=shared' > /etc/systemd/system/systemd-udevd.service.d/shared-mount-ns.conf
  # Reload systemctl daemon and restart udev
  sudo systemctl daemon-reload
  sudo systemctl restart systemd-udevd.service
  # Overwrite existing tftp configuration
  sudo echo '# /etc/default/tftpd-hpa
TFTP_USERNAME="tftp"
TFTP_DIRECTORY="/tftp"
TFTP_ADDRESS="0.0.0.0:69"
TFTP_OPTIONS="--secure --create"' > /etc/default/tftpd-hpa
  # Make /tftp directory and set permissions
  sudo mkdir /tftp
  sudo chown tftp. /tftp
  # Restart tftpd-hpa and enable on startup
  sudo systemctl restart tftpd-hpa
  sudo systemctl enable tftpd-hpa
  # should all be done now!
}

start
