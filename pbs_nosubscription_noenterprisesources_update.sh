#!/bin/bash

# Tonton Jo - 2020
# Join me on Youtube: https://www.youtube.com/channel/UCnED3K6K5FDUp-x_8rwpsZw

# Script for initial proxomox subscription and sources list settings
# https://www.youtube.com/watch?v=X-a_LGKFIPg

# USAGE
# You can run this scritp directly using:
# wget -O - https://raw.githubusercontent.com/Tontonjo/proxmox/master/pbs_nosubscription_noenterprisesources_update.sh | bash

varversion=1.2
# V1.0: Initial Release
# V1.2: fix repository names

# Sources:
# https://pve.proxmox.com/wiki/Package_Repositories
# https://www.sysorchestra.com/remove-proxmox-5-3-no-valid-subscription-message/
# https://www.svennd.be/proxmox-ve-5-0-fix-updates-upgrades/

# I assume you know what you are doing have a backup and have a default configuration.

# If you want to manually enter commands below in order: enter thoses without "#" :-)


echo "----------------------------------------------------------------"
echo "Tonton Jo - 2020"
echo "Proxmox subscription and sources inital setup V$varversion"
echo "----------------------------------------------------------------"
#1: Defining distribution name:

echo "- Defining distribution name for sources list"
distribution=$(. /etc/*-release;echo $VERSION_CODENAME)

#2: Remove Subscription:

echo "- Removing No Valid Subscription Message"
sed -i.bak "s/data.status !== 'Active'/false/g" /usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js && systemctl restart proxmox-backup-proxy.service

#3: Edit sources list:

echo "- Checking Sources list"
if grep -Fxq "deb http://download.proxmox.com/debian/pbs $distribution pbs-no-subscription" /etc/apt/sources.list
then
    echo "- Source looks alredy configured - Skipping"
else
    echo "- Adding new entry to sources.list"
    sed -i "\$adeb http://download.proxmox.com/debian/pbs $distribution pbs-no-subscription" /etc/apt/sources.list
fi

echo "- Checking Enterprise Source list"
if grep -Fxq "#deb https://enterprise.proxmox.com/debian/pbs $distribution pbs-enterprise" /etc/apt/sources.list.d/pbs-enterprise.list
then
    echo "- Entreprise repo looks already commented - Skipping"
else
   echo "- Hiding Enterprise sources list"
   sed -i 's/^/#/' /etc/apt/sources.list.d/pbs-enterprise.list
fi


#4: update:
echo "- Updating System"
apt-get -y update
apt-get -y upgrade
