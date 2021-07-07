## Tonton Jo - 2021
Join me on Youtube: https://www.youtube.com/c/tontonjo

If you find this usefull, please think about [Buying me a coffee](https://www.buymeacoffee.com/tontonjo)
and to [Subscribe to my youtube channel](http://youtube.com/channel/UCnED3K6K5FDUp-x_8rwpsZw?sub_confirmation=1)

# Voici les quelques commandes utilisées pour mettre à jour Proxmox de la V6 à la V7

## 1 - Mise à jour complète du système:  
```shell
apt-get update
apt-get upgrade
apt-get dist-ugprade
```  
## 2 - Checklist de contrôle:  
```shell
pve6to7 --full
```  
## 3 - Mise à jour des dépôts / repository de Buster (Debian 10) vers Bullseye (Debian 11)  
```shell
sed -i 's/buster\/updates/bullseye-security/g;s/buster/bullseye/g' /etc/apt/sources.list
```  
## 4 - Mise à jour vers Proxmox 11  
```shell
apt-get update
apt-get dist-upgrade
```  
## 5 - Reboot final  
```shell
reboot now
```

# Liens utiles:
[Proxmox v7 changelog](https://pve.proxmox.com/wiki/Roadmap#Proxmox_VE_7.0)
[Proxmox V6 to V7 Guide](https://pve.proxmox.com/wiki/Upgrade_from_6.x_to_7.0)
