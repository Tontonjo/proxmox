#!/bin/bash

# Tonton Jo - 2021
# Join me on Youtube: https://www.youtube.com/c/tontonjo

# This script is intended to update Proxmox and if there's a no-subscription source set, it removes the no-subscription message.
# https://www.youtube.com/watch?v=X-a_LGKFIPg

# USAGE
# You can run this script directly using:
# wget -q -O - https://raw.githubusercontent.com/Tontonjo/proxmox/master/proxmox_updater.sh | bash

version=3.6
# V1.0: Initial Release with support for both PVE and PBS
# V2.0: Old scripts points there now :-)
# V2.1: Some corrections and enhancements in the subscription part
# V2.2: Enhanced sileeeeence
# V3.0: removed repository configuration wich is now in Proxmox Toolbox - Enhanced configuration for no subscription. Tool now named "proxmox_updater.sh"
# V3.1: correction to no-subscription message removal detection
# V3.2: Much better and smarter way to remove subscription message (credits to @adrien Linuxtricks)
# V3.3: Fix remove subscription message detection
# V3.4: Add echo when restarting proxy
# V3.5: Various typo
# V3.6: now directly redirect to proxmox-toolox - this script wont be updated

# Sources:
# https://pve.proxmox.com/wiki/Package_Repositories
# https://www.sysorchestra.com/remove-proxmox-5-3-no-valid-subscription-message/
# https://www.svennd.be/proxmox-ve-5-0-fix-updates-upgrades/
# https://www.linuxtricks.fr/wiki/proxmox-quelques-infos

# I assume you know what you are doing, have a backup and have a default configuration.

echo "----------------------------------------------------------------"
echo "Tonton Jo - 2021"
echo "Proxmox updateder V$version"
echo "----------------------------------------------------------------"

echo "- Please now use proxmox_toolbox.sh with -u option to update:"
echo "- wget -qO - https://raw.githubusercontent.com/Tontonjo/proxmox_toolbox/main/proxmox_toolbox.sh | bash /dev/stdin -u"

wget -qO - https://raw.githubusercontent.com/Tontonjo/proxmox_toolbox/main/proxmox_toolbox.sh | bash /dev/stdin -u
