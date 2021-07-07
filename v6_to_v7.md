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
## 4 - Reboot final  
```shell
reboot now
```
