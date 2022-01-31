# Proxmox

## Tonton Jo - 2021  
### Join the community:
[![Youtube channel](https://github-readme-youtube-stats.herokuapp.com/subscribers/index.php?id=UCnED3K6K5FDUp-x_8rwpsZw&key=AIzaSyA3ivqywNPQz0xFZBHfPDKzh1jFH5qGD_g)](http://youtube.com/channel/UCnED3K6K5FDUp-x_8rwpsZw?sub_confirmation=1)
[![Discord Tonton Jo](https://badgen.net/discord/members/2NQskxZjfp?label=Discord%20Tonton%20Jo,%20&icon=discord)](https://discord.gg/2NQskxZjfp)
### Support the channel with one of the following link:
[![Ko-Fi](https://badgen.net/badge/Buy%20me%20a%20Coffee/Link?icon=buymeacoffee)](https://ko-fi.com/tontonjo)
[![Infomaniak](https://badgen.net/badge/Infomaniak/Affiliated%20link?icon=K)](https://www.infomaniak.com/goto/fr/home?utm_term=6151f412daf35)
[![Express VPN](https://badgen.net/badge/Express%20VPN/Affiliated%20link?icon=K)](https://www.xvuslink.com/?a_fid=TontonJo)  
## Informations:  
This repository contains somes scripts and tips for Proxmox hypervisor and backup server

Find here [more of my videos about proxmox](https://www.youtube.com/playlist?list=PLU73OWQhDzsTfsnczSJWENIpZn1CNMzNP)

## Usefull commands - commands.md
You'll find there some usefull commands to manage and supervise your proxmox host:  
[Proxmox usefull commands](https://github.com/Tontonjo/proxmox/blob/master/commands.md)

## New tool - Poxmox Toolbox:
I wrote a new tool to get small configurations done in no time:
Please give it a try because some of the tools hosted here were migrated in it
[Proxmox Toolbox](https://github.com/Tontonjo/proxmox_toolbox)

### proxmox_updater.sh
![Script](https://i.ibb.co/VY57ty3/Screenshot-2021-05-25-094719.png)  
full upgrade server  
Disable no subscription message  
To set sources - use [Proxmox Toolbox](https://github.com/Tontonjo/proxmox_toolbox)  
This tool update proxmox host and if noenterprise repos are setup, remove no-subscription message.
```shell
wget -q -O - https://github.com/Tontonjo/proxmox/raw/master/proxmox_updater.sh | bash
```  
### ez_proxmox_mail_configurator.sh
This tool is now part of Proxmox Toolbox and will no longer be updated here.
[Proxmox Toolbox](https://github.com/Tontonjo/proxmox_toolbox)
