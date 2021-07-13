#!/bin/bash

# Tonton Jo - 2021
# Join me on Youtube: https://www.youtube.com/c/tontonjo

# This script update Proxmox and if there's a no-subscription source set, it remove the no-subcription message.
# removing subscription message is known to deny update trough GUI.
# This script used to contain the no-subscription repository setup wich is now part of "proxmox_toolbox"

# https://www.youtube.com/watch?v=X-a_LGKFIPg

# USAGE
# You can run this script directly using:
# wget -q -O - https://raw.githubusercontent.com/Tontonjo/proxmox/master/proxmox_updater.sh | bash

version=3.0
# V1.0: Initial Release with support for both PVE and PBS
# V2.0: Old scripts points there now :-)
# V2.1: Some corrections and enhancements in the subscription part
# V2.2: Enhanced sileeeeence
# V3.0: removed repository configuration wich is now in Proxmox Toolbox - Enhanced configuration for no subscription. Tool now named "proxmox_updater.sh"

# Sources:
# https://pve.proxmox.com/wiki/Package_Repositories
# https://www.sysorchestra.com/remove-proxmox-5-3-no-valid-subscription-message/
# https://www.svennd.be/proxmox-ve-5-0-fix-updates-upgrades/

# I assume you know what you are doing, have a backup and have a default configuration.

echo "----------------------------------------------------------------"
echo "Tonton Jo - 2021"
echo "Proxmox updateder V$version"
echo "----------------------------------------------------------------"

# -----------------ENVIRONNEMENT VARIABLES----------------------
pve_log_folder="/var/log/pve/tasks/"
proxmoxlib="/usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js"
# ---------------END OF ENVIRONNEMENT VARIABLES-----------------

#1: Zpdate:
echo "- Updating System"
apt-get update -y -qq
apt-get upgrade -y -qq
apt-get dist-upgrade -y -qq

#2: Remove Subscription:
#checking if no subscription sources are set and if file is already edited in order to not edit again
if grep -Ewqi "no-subscription" /etc/apt/sources.list; then
	if grep -Ewqi "void({" $proxmoxlib; then
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
else
echo "- Host has no no-subscription repository configured"
echo "- Please configure them before with proxmox_toolbox"
fi
