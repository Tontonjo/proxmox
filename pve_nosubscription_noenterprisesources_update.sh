#!/bin/bash

# Tonton Jo - 2020
# Join me on Youtube: https://www.youtube.com/c/TontonJo

# Script for initial proxomox subscription and sources list settings
# https://www.youtube.com/watch?v=X-a_LGKFIPg

# USAGE
# You can run this scritp directly using:
# wget -O - https://raw.githubusercontent.com/Tontonjo/proxmox/master/pve_pbs_nosubscription_noenterprisesources.sh | bash

varversion=1.5
# V1.0: Initial Release
# V1.1: echo was writing source at end of last line - replaced with sed
# V1.2: updated license removal command
# V1.3: put license removal after update - makes more sense
# V1.4: added dist-upgrade to avoid bricking things
# V1.5: redirect to new script for pve and PBS

# Sources:
# https://pve.proxmox.com/wiki/Package_Repositories
# https://www.sysorchestra.com/remove-proxmox-5-3-no-valid-subscription-message/
# https://www.svennd.be/proxmox-ve-5-0-fix-updates-upgrades/
# https://johnscs.com/remove-proxmox51-subscription-notice/

# I assume you know what you are doing have a backup and have a default configuration.

# Redirect to new script version - keeping this cause the link was shared.

echo "------------------------------------------------------------------------------------------------------------------------------"
echo "- Redirecting to new script at https://github.com/Tontonjo/proxmox/blob/master/pve_pbs_nosubscription_noenterprisesources.sh"
echo "------------------------------------------------------------------------------------------------------------------------------"

wget -O - https://raw.githubusercontent.com/Tontonjo/proxmox/master/pve_pbs_nosubscription_noenterprisesources.sh | bash
