## Tonton Jo - 2021
Join me on Youtube: https://www.youtube.com/c/tontonjo

If you find this usefull, please think about [Buying me a coffee](https://www.buymeacoffee.com/tontonjo)
and to [Subscribe to my youtube channel](http://youtube.com/channel/UCnED3K6K5FDUp-x_8rwpsZw?sub_confirmation=1)

Source: https://pbs.proxmox.com/wiki/index.php/Upgrade_from_1.1_to_2.x  

# Voici les quelques commandes utilisées pour mettre à jour Proxmox Backup Server de la version 1.1 à la version 2.X

## 1 - Mise à jour complète du système:  
```shell
apt-get update
apt-get dist-ugprade
```  
## 2 - Checklist de contrôle:  
```shell
proxmox-backup-manager versions
```  
## 3 - Mise à jour des dépôts / repository de Buster (Debian 10) vers Bullseye (Debian 11)  
```shell
sed -i 's/buster\/updates/bullseye-security/g;s/buster/bullseye/g' /etc/apt/sources.list
```  
## 4 - Arrêt des services
```shell
systemctl stop proxmox-backup-proxy.service proxmox-backup.service
```  
## 5 - Mise à jour vers Proxmox 2.X
```shell
apt-get update
apt-get dist-upgrade
```  
## 6 - Redémarrage du serveur PBS
```shell  
reboot now
```  
## 7 - Nouvelle mise à jour
```shell  
apt-get update
apt-get upgrade
```  
## 8 - Nettoyage des anciens paquets
```shell  
apt autoremove
```  

# Liens utiles:
[Proxmox BS V2.x changelog](https://forum.proxmox.com/threads/proxmox-backup-server-2-0-released.92509/)  
[Guide Proxmox BS 1.1 vers 2.x](https://pbs.proxmox.com/wiki/index.php/Upgrade_from_1.1_to_2.x)  
