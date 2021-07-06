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
  sudo echo '#  SPDX-License-Identifier: LGPL-2.1+
#
#  This file is part of systemd.
#
#  systemd is free software; you can redistribute it and/or modify it
#  under the terms of the GNU Lesser General Public License as published by
#  the Free Software Foundation; either version 2.1 of the License, or
#  (at your option) any later version.

[Unit]
Description=udev Kernel Device Manager
Documentation=man:systemd-udevd.service(8) man:udev(7)
DefaultDependencies=no
After=systemd-sysusers.service systemd-hwdb-update.service
Before=sysinit.target
ConditionPathIsReadWrite=/sys

[Service]
Type=notify
OOMScoreAdjust=-1000
Sockets=systemd-udevd-control.socket systemd-udevd-kernel.socket
Restart=always
RestartSec=0
ExecStart=/lib/systemd/systemd-udevd
KillMode=mixed
WatchdogSec=3min
TasksMax=infinity
PrivateMounts=no
MemoryDenyWriteExecute=yes
RestrictRealtime=yes
RestrictAddressFamilies=AF_UNIX AF_NETLINK AF_INET AF_INET6
SystemCallArchitectures=native
LockPersonality=yes
IPAddressDeny=any' > /lib/systemd/system/systemd-udevd.service
  # Reload systemctl daemon and restart udev
  sudo systemctl daemon-reload
  sudo systemctl restart systemd-udevd.service
  # Overwrite existing tftp configuration
  sudo echo '# /etc/default/tftpd-hpa
TFTP_USERNAME="root"
TFTP_DIRECTORY="/media"
TFTP_ADDRESS="0.0.0.0:69"
TFTP_OPTIONS="--secure --create"' > /etc/default/tftpd-hpa
  # Restart tftpd-hpa and enable on startup
  sudo systemctl restart tftpd-hpa
  sudo systemctl enable tftpd-hpa
  # should all be done now!
}

start
