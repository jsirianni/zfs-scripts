#!/bin/bash
cd $(dirname $0)
#
# Replace "tank" with the name of your zpool
# Replace "dataset" with the name of your dataset
# Additional datasets can be added by copying the dataset section
# This script installs auto snapshots and enalbles them globally
# Auto snapshots are not actually taken unless you change false to true for each snapshot type
#
# View snapshot information with 'sudo zfs get all | grep snapshot'
#


#
# Install required packages
#
sudo apt-get install unzip make


#
# Add repo and install auto snapshots
#
sudo wget https://github.com/jsirianni/zfs-autosnapshot-packages/raw/master/zfs-auto-snapshot-master.zip -P /tmp
sudo unzip /tmp/zfs-auto-snapshot-master.zip -d /tmp/
sudo make install -C /tmp/zfs-auto-snapshot-master


#
# Enable top level snapshots, and then disable each type individually
#
sudo zfs set com.sun:auto-snapshot=true tank
sudo zfs set com.sun:auto-snapshot:monthly=false tank
sudo zfs set com.sun:auto-snapshot:weekly=false tank
sudo zfs set com.sun:auto-snapshot:daily=false tank
sudo zfs set com.sun:auto-snapshot:hourly=false tank
sudo zfs set com.sun:auto-snapshot:frequent=false tank


#
# Enable dataset level snapshots, and then disable each type invididually 
#
sudo zfs set com.sun:auto-snapshot=true tank/dataset
sudo zfs set com.sun:auto-snapshot:monthly=false tank/dataset
sudo zfs set com.sun:auto-snapshot:weekly=false tank/dataset
sudo zfs set com.sun:auto-snapshot:daily=false tank/dataset
sudo zfs set com.sun:auto-snapshot:hourly=false tank/dataset
sudo zfs set com.sun:auto-snapshot:frequent=false tank/dataset
