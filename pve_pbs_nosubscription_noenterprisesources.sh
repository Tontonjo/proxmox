#!/bin/bash

# Tonton Jo - 2021
# Join me on Youtube: https://www.youtube.com/c/tontonjo

# Script for initial proxomox subscription and sources list settings
# https://www.youtube.com/watch?v=X-a_LGKFIPg

# USAGE
# You can run this scritp directly using:
# wget -q -O - https://raw.githubusercontent.com/Tontonjo/proxmox/master/pve_pbs_nosubscription_noenterprisesources.sh | bash

varversion=2.1
# V1.0: Initial Release with support for both PVE and PBS
# V2.0: Old scripts points there now :-)
# V2.1: Some corrections and enhancements in the subscription part

# Sources:
# https://pve.proxmox.com/wiki/Package_Repositories
# https://www.sysorchestra.com/remove-proxmox-5-3-no-valid-subscription-message/
# https://www.svennd.be/proxmox-ve-5-0-fix-updates-upgrades/

# I assume you know what you are doing, have a backup and have a default configuration.

echo "----------------------------------------------------------------"
echo "Tonton Jo - 2020"
echo "Proxmox subscription and sources inital setup V$varversion"
echo "----------------------------------------------------------------"

# -----------------ENVIRONNEMENT VARIABLES----------------------
# Hostname used to generate sensor name
pve_log_folder="/var/log/pve/tasks/"
proxmoxlib="/usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js"
distribution=$(. /etc/*-release;echo $VERSION_CODENAME)
# ---------------END OF ENVIRONNEMENT VARIABLES-----------------

# Check if server is PBS or PVE using /var/log/pve/tasks/
if [ -d "$pve_log_folder" ]; then
  echo "- Server is a PVE host"
#2: Edit sources list:
  echo "- Checking Sources list"
    if grep -Fxq "deb http://download.proxmox.com/debian/pve $distribution pve-no-subscription" /etc/apt/sources.list
     then
      echo "-- Source looks alredy configured - Skipping"
    else
      echo "-- Adding new entry to sources.list"
      sed -i "\$adeb http://download.proxmox.com/debian/pve $distribution pve-no-subscription" /etc/apt/sources.list
    fi
  echo "- Checking Enterprise Source list"
    if grep -Fxq "#deb https://enterprise.proxmox.com/debian/pve $distribution pve-enterprise" /etc/apt/sources.list.d/pve-enterprise.list
    then
     echo "-- Entreprise repo looks already commented - Skipping"
    else
     echo "-- Hiding Enterprise sources list"
     sed -i 's/^/#/' /etc/apt/sources.list.d/pve-enterprise.list
   fi
else
  echo "- Server is a PBS host"
  echo "- Checking Sources list"
    if grep -Fxq "deb http://download.proxmox.com/debian/pbs $distribution pbs-no-subscription" /etc/apt/sources.list
    then
      echo "-- Source looks alredy configured - Skipping"
    else
     echo "-- Adding new entry to sources.list"
      sed -i "\$adeb http://download.proxmox.com/debian/pbs $distribution pbs-no-subscription" /etc/apt/sources.list
    fi
  echo "- Checking Enterprise Source list"
    if grep -Fxq "#deb https://enterprise.proxmox.com/debian/pbs $distribution pbs-enterprise" /etc/apt/sources.list.d/pbs-enterprise.list
      then
      echo "-- Entreprise repo looks already commented - Skipping"
    else
      echo "-- Hiding Enterprise sources list"
      sed -i 's/^/#/' /etc/apt/sources.list.d/pbs-enterprise.list
    fi
fi

#3: update:
# "-qq -o Dpkg::Use-Pty=0 " is a trick to silence DPKG forked by apt-get

echo "- Updating System"
apt-get update -y -qq
apt-get -qq -o Dpkg::Use-Pty=0 upgrade -y
apt-get -qq -o Dpkg::Use-Pty=0 dist-upgrade -y -qq

#4: Remove Subscription:
#checking if file is already edited in order to not edit again
if grep -Ewqi "void" $proxmoxlib; then
echo "- Subscription Message already removed - Skipping"
else
if [ -d "$pve_log_folder" ]; then
echo "- Removing No Valid Subscription Message for PVE"
sed -Ezi.bak "s/(Ext.Msg.show\(\{\s+title: gettext\('No valid sub)/void\(\{ \/\/\1/g" $proxmoxlib && systemctl restart pveproxy.service
else 
echo "- Removing No Valid Subscription Message for PBS"
sed -Ezi.bak "s/(Ext.Msg.show\(\{\s+title: gettext\('No valid sub)/void\(\{ \/\/\1/g" $proxmoxlib && systemctl restart proxmox-backup-proxy.service
fi
fi
