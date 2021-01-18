#!/bin/bash

# Tonton Jo - 2021
# Join me on Youtube: https://www.youtube.com/c/tontonjo

# Script for initial proxomox subscription and sources list settings
# https://www.youtube.com/watch?v=X-a_LGKFIPg

# USAGE
# You can run this scritp directly using:
# wget -O - https://raw.githubusercontent.com/Tontonjo/proxmox/master/pbs_nosubscription_noenterprisesources_update.sh | bash

varversion=1.6
# V1.0: Initial Release
# V1.2: fix repository names
# V1.3: Correct subscription removal
# V1.4: put license removal after update - makes more sense
# V1.5: added dist-upgrade to avoid bricking things
# V1.6: Redirect to new script - keeping cause link was shared.


# Sources:
# https://pve.proxmox.com/wiki/Package_Repositories
# https://www.sysorchestra.com/remove-proxmox-5-3-no-valid-subscription-message/
# https://www.svennd.be/proxmox-ve-5-0-fix-updates-upgrades/

# I assume you know what you are doing have a backup and have a default configuration.

echo "------------------------------------------------------------------------------------------------------------------------------"
echo "- Redirecting to new script at https://github.com/Tontonjo/proxmox/blob/master/pve_pbs_nosubscription_noenterprisesources.sh"
echo "------------------------------------------------------------------------------------------------------------------------------"

wget -O - https://raw.githubusercontent.com/Tontonjo/proxmox/master/pve_pbs_nosubscription_noenterprisesources.sh | bash
