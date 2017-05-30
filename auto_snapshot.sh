#!/bin/bash
cd $(dirname $0)

#
# Replace "zpool" with the name of your zpool
#
# Replace "dataset" with the name of your dataset
#
# Datasets can be added by copying lines 20-26 and replacing the dataset names
#


# Disable top level snapshots & enable weekly, daily, hourly, frequent snapshots for mounted zpool
sudo zfs set com.sun:auto-snapshot=true data
sudo zfs set com.sun:auto-snapshot:monthly=false data
sudo zfs set com.sun:auto-snapshot:weekly=false data
sudo zfs set com.sun:auto-snapshot:daily=false data
sudo zfs set com.sun:auto-snapshot:hourly=false data
sudo zfs set com.sun:auto-snapshot:frequent=false data


sudo zfs set com.sun:auto-snapshot=true data/data
sudo zfs set com.sun:auto-snapshot:monthly=true data/data
sudo zfs set com.sun:auto-snapshot:weekly=true data/data
sudo zfs set com.sun:auto-snapshot:daily=true data/data
sudo zfs set com.sun:auto-snapshot:hourly=false data/data
sudo zfs set com.sun:auto-snapshot:frequent=false data/data

sudo zfs set com.sun:auto-snapshot=true data/media
sudo zfs set com.sun:auto-snapshot:monthly=true data/media
sudo zfs set com.sun:auto-snapshot:weekly=true data/media
sudo zfs set com.sun:auto-snapshot:daily=false data/media
sudo zfs set com.sun:auto-snapshot:hourly=false data/media
sudo zfs set com.sun:auto-snapshot:frequent=false data/media
