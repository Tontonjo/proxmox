#!/bin/bash

# Tonton Jo - 2021
# Join me on Youtube: https://www.youtube.com/c/tontonjo

# Script for initial proxomox subscription and sources list settings
# https://www.youtube.com/watch?v=X-a_LGKFIPg

# USAGE
# You can run this script directly using:
# wget -q -O - https://raw.githubusercontent.com/Tontonjo/proxmox/master/pve_pbs_nosubscription_noenterprisesources.sh | bash

version=2.2
# V1.0: Initial Release with support for both PVE and PBS
# V2.0: Old scripts points there now :-)
# V2.1: Some corrections and enhancements in the subscription part
# V2.2: Enhanced sileeeeence
# V3.0: removed repository configuration in Proxmox Toolbox - Enhanced configuration for no subscription. Tool now named "proxmox_updater.sh"

# Sources:
# https://pve.proxmox.com/wiki/Package_Repositories
# https://www.sysorchestra.com/remove-proxmox-5-3-no-valid-subscription-message/
# https://www.svennd.be/proxmox-ve-5-0-fix-updates-upgrades/

# I assume you know what you are doing, have a backup and have a default configuration.

echo "----------------------------------------------------------------"
echo "Tonton Jo - 2021"
echo "Proxmox subscription and sources inital setup V$version"
echo "----------------------------------------------------------------"

# -----------------ENVIRONNEMENT VARIABLES----------------------
pve_log_folder="/var/log/pve/tasks/"
proxmoxlib="/usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js"
distribution=$(. /etc/*-release;echo $VERSION_CODENAME)
# ---------------END OF ENVIRONNEMENT VARIABLES-----------------

#1: update:
echo "- Updating System"
apt-get update -y -qq
apt-get upgrade -y -qq
apt-get dist-upgrade -y -qq

#2: Remove Subscription:
#checking if no subscription sources are set and if file is already edited in order to not edit again
if grep -Ewqi "no-subscription" /etc/apt/sources.list; then
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
fi
