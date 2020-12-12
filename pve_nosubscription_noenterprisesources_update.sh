#!/bin/bash

# Tonton Jo - 2020
# Join me on Youtube: https://www.youtube.com/channel/UCnED3K6K5FDUp-x_8rwpsZw

# Script for initial proxomox subscription and sources list settings
# https://www.youtube.com/watch?v=X-a_LGKFIPg

# USAGE
# You can run this scritp directly using:
# wget -O - https://raw.githubusercontent.com/Tontonjo/proxmox/master/pve_nosubscription_noenterprisesources_update.sh | bash

varversion=1.4
# V1.0: Initial Release
# V1.1: echo was writing source at end of last line - replaced with sed
# V1.2: updated license removal command
# V1.3: put license removal after update - makes more sense
# V1.4: added dist-upgrade to avoid bricking things

# Sources:
# https://pve.proxmox.com/wiki/Package_Repositories
# https://www.sysorchestra.com/remove-proxmox-5-3-no-valid-subscription-message/
# https://www.svennd.be/proxmox-ve-5-0-fix-updates-upgrades/
# https://johnscs.com/remove-proxmox51-subscription-notice/

# I assume you know what you are doing have a backup and have a default configuration.

echo "----------------------------------------------------------------"
echo "Tonton Jo - 2020"
echo "Proxmox subscription and sources inital setup V$varversion"
echo "----------------------------------------------------------------"
#1: Defining distribution name:

echo "- Defining distribution name for sources list"
distribution=$(. /etc/*-release;echo $VERSION_CODENAME)


#2: Edit sources list:

echo "- Checking Sources list"
if grep -Fxq "deb http://download.proxmox.com/debian/pve $distribution pve-no-subscription" /etc/apt/sources.list
then
    echo "- Source looks alredy configured - Skipping"
else
    echo "- Adding new entry to sources.list"
    sed -i "\$adeb http://download.proxmox.com/debian/pve $distribution pve-no-subscription" /etc/apt/sources.list
fi

echo "- Checking Enterprise Source list"
if grep -Fxq "#deb https://enterprise.proxmox.com/debian/pve $distribution pve-enterprise" /etc/apt/sources.list.d/pve-enterprise.list
then
    echo "- Entreprise repo looks already commented - Skipping"
else
   echo "- Hiding Enterprise sources list"
   sed -i 's/^/#/' /etc/apt/sources.list.d/pve-enterprise.list
fi


#3: update:
echo "- Updating System"
apt-get -qq update
apt-get -qq upgrade
apt-get -qq dist-upgrade

#4: Remove Subscription:
echo "- Removing No Valid Subscription Message"
sed -Ezi.bak "s/(Ext.Msg.show\(\{\s+title: gettext\('No valid sub)/void\(\{ \/\/\1/g" /usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js && systemctl restart pveproxy.service

