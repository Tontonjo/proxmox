# Proxmox

## Tonton Jo - 2021
Join me on Youtube: https://www.youtube.com/c/tontonjo

If you find this usefull, please think about [Buying me a coffee](https://www.buymeacoffee.com/tontonjo)
and to [Subscribe to my youtube channel](http://youtube.com/channel/UCnED3K6K5FDUp-x_8rwpsZw?sub_confirmation=1)

This repository contains somes scripts and tips for Proxmox hypervisor and backup server

Find here [more of my videos about proxmox](https://i.ibb.co/VY57ty3/Screenshot-2021-05-25-094719.png)


### pve_pbs_nosubscription_noenterprisesources.sh
Set no enterprise sources
![Script](https://i.ibb.co/RPSBf0P/Screenshot-2020-09-18-104948.png)
Disable no subscription message

full upgrade server

#### USAGE

You can run this script directly using:

wget -q -O - https://raw.githubusercontent.com/Tontonjo/proxmox/master/pve_pbs_nosubscription_noenterprisesources.sh | bash

### ez_proxmox_mail_configurator.sh
Helps you to enable email notifications on your Proxmox VE server but can be used for every postfix configuration

#### USAGE
You can run this scritp directly using:

wget -q https://raw.githubusercontent.com/Tontonjo/proxmox/master/ez_proxmox_mail_configurator.sh

bash ez_proxmox_mail_configurator.sh
