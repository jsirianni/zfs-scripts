#!/bin/bash
cd $(dirname $0)

#
# Replace "zpool" with the name of your zpool
#
# Replace "dataset" with the name of your dataset
#
# Datasets can be added by copying lines 20-26 and replacing the dataset names
#


# Add repo and install auto snapshots
sudo add-apt-repository ppa:bob-ziuchkovski/zfs-auto-snapshot
sudo apt-get update
sudo apt-get install -y zfs-auto-snapshot


# Disable top level snapshots & enable weekly, daily, hourly, frequent snapshots for mounted zpool
sudo zfs set com.sun:auto-snapshot=false zpool
sudo zfs set com.sun:auto-snapshot=true zpool/dataset
sudo zfs set com.sun:auto-snapshot:monthly=false zpool/dataset
sudo zfs set com.sun:auto-snapshot:weekly=true zpool/dataset
sudo zfs set com.sun:auto-snapshot:daily=true zpool/dataset
sudo zfs set com.sun:auto-snapshot:hourly=true zpool/dataset
sudo zfs set com.sun:auto-snapshot:frequent=false zpool/dataset
