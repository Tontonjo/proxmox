#!/bin/bash

# Tonton Jo - 2020
# Join me on Youtube: https://www.youtube.com/channel/UCnED3K6K5FDUp-x_8rwpsZw

# Script aimed to help pass a disk directly to a VM

varversion=1.0
#V1.0: Initial Release - proof of concept


# USAGE
# You can run this scritp directly using:
# wget https://raw.githubusercontent.com/Tontonjo/proxmox/master/drive-passtrough.sh
# bash drive-passtrough.sh

echo "----------------------------------------------------------------"
echo "Tonton Jo - 2020"
echo "Proxmox drive passtrough helper"
echo "----------------------------------------------------------------"

echo "Target VM ID (100): "
read 'varvmid'
echo "Target virtual drive ID (scsi1, sata2, ide3): "
read 'vardriveid'
echo "Drive to pass trough? (/dev/sda - /dev/disk/by-id/yyyy): "
read 'vardrive'

qm set $varvmid -$vardriveid $vardrive
