# Proxmox

## Tonton Jo  
### Join the community:
[![Youtube channel](https://github-readme-youtube-stats.herokuapp.com/subscribers/index.php?id=UCnED3K6K5FDUp-x_8rwpsZw&key=AIzaSyA3ivqywNPQz0xFZBHfPDKzh1jFH5qGD_g)](http://youtube.com/channel/UCnED3K6K5FDUp-x_8rwpsZw?sub_confirmation=1)
[![Discord Tonton Jo](https://badgen.net/discord/members/h6UcpwfGuJ?label=Discord%20Tonton%20Jo%20&icon=discord)](https://discord.gg/h6UcpwfGuJ)
### Support the channel with one of the following link:
[![Ko-Fi](https://badgen.net/badge/Buy%20me%20a%20Coffee/Link?icon=buymeacoffee)](https://ko-fi.com/tontonjo)
[![Infomaniak](https://badgen.net/badge/Infomaniak/Affiliated%20link?icon=K)](https://www.infomaniak.com/goto/fr/home?utm_term=6151f412daf35)
[![Express VPN](https://badgen.net/badge/Express%20VPN/Affiliated%20link?icon=K)](https://www.xvuslink.com/?a_fid=TontonJo)   
## Informations:  
This repository contains somes scripts and tips for Proxmox hypervisor and backup server

Find here [more of my videos about proxmox](https://www.youtube.com/playlist?list=PLU73OWQhDzsTfsnczSJWENIpZn1CNMzNP)

## Proxmox Toolbox - all-in-one setup tool!
This [Proxmox Toolbox](https://github.com/Tontonjo/proxmox_toolbox) will help you get your Proxmox VE and BS installations configured and secured in no time:
Set sources - New update command (proxmox-update) - Remove subsciption message - Security with Fail2ban - snmp - mail notifications - And much more

# Usefull doc:
[Move a disk from a VM to another one](https://pve.proxmox.com/wiki/Moving_disk_image_from_one_KVM_machine_to_another)

# Usefull commands:
You'll find there some usefull commands used for proxmox and more generally debian

# 1 - Proxmox General

## 1.1 - Drives Management

### 1.1.1 - Find a disc with ID:
```shell
ls /dev/disk/by-id/ -la
```
```shell
ls /dev/disk/by-id/ -la | grep "serial"
```
## 1.1.2 - list disk informations: Replace X
```shell
lsblk -o name,model,serial,uuid /dev/sdX
```
##  1.1.3 - find disk UUID or partition UUID
```shell
ls -l /dev/disk/by-uuid
```
```shell
ls -l /dev/disk/by-partuuid
```

## 1.1.4 - Wipe Disk
```shell
wipefs -af /dev/sdX
```
## 1.1.5 - Read actual partition status after change
```shell
hdparm -z /dev/sdX
```
```shell
echo 1 > /sys/block/sdX/device/rescan
```  
##  1.1.6 - Find the actual blocksize of all disks - Usually 4k
```shell
lsblk -o NAME,PHY-SeC
```

###  1.1.7 - Test speed of drive (hdparm needed)
```shell
hdparm -t /dev/$sdX
```  
##  1.2 - Zpool Management  
###  1.2.1 - Remove import of removed pools at startup:  
- Identify your pools:
```shell
systemctl | grep zfs
```
- Remove import of a pool at boot (remove old pools from load)
```shell
systemctl disable zfs-import@zpoolname.service
```
### 1.2.2 - Find ARC RAM usage for Zpool:
```shell
awk '/^size/ { print $1 " " $3 / 1048576 }' < /proc/spl/kstat/zfs/arcstats
```

### 1.2.3 - Find Compression ratio and used space:
```shell
zfs list -o name,avail,used,refer,lused,lrefer,mountpoint,compress,compressratio
``` 

### 1.2.4 - Replace Zpool Drive:
```shell
zpool replace pool /old/drive /new/drive
```

### 1.2.5 - Mark a pool as OK - Clear errors on pool and drives
```shell
zpool clear "poolname"
```

### 1.2.6 - Get Zpool version:
```shell
zpool --version
```

### 1.2.7 - Ugrade a zpool:
```shell
zpool upgrade "$poolname"
```  
### 1.2.8 - Zpool options settings
- Get your $poolname
```shell
zfs list
```
- find actual options - filter if necessary
```shell
zfs get all 
```
```shell
zfs get all | grep atime
```
- Set new option value
```shell
zfs set atime=off $poolname
```
```shell
zfs set compression=off $poolname
```  
### 1.2.9 - If pool is created with /dev/sdX instead of ID (wich may lead to mount fail)
```shell
zpool export $poolname
```  
```shell
zpool import -d /dev/disk/by-id -aN
```  
## 1.3 - Monitoring

### 1.3.1 - Live disk IO
```shell
watch -n 1 "zpool iostat -v"
```

# 2 - Proxmox Virtual Environement  
## 2.1 - Stop all services:  
```shell
for i in pve-cluster pvedaemon vz qemu-server pveproxy pve-cluster; do systemctl stop $i ; done
```  
## 2.2 - Regenerate console login screen (usefull after ip changes)
```shell
pvebanner
```  
## 2.3 - VM Management

### 2.3.1 - Disk passtrough
```shell
qm set $vmid -scsi0 /dev/sdX
```
###  2.3.2 - Appliance Import
```shell
qm importdisk $vmid pathtoappliance.ova local-lvm
```
##  2.3.3 - Appliance Export
- Identifiy the disk of a vm
```shell
qm config $vmid
```  
- Check absolute path ($absolutepath) for drive as seen by the OS
```shell
absolutepath=$(pvesm path local-lvm:vm-100-disk-0)
```  
```shell
echo $absolutepath
```  
- Export the drive wanted, watch for the format to be correct :-)
```shell
qemu-img convert -O qcow2 -f raw $absolutepath OUTPUT.qcow2
```  

## 3 - Proxmox Backup Server

### 3.1 - Recover / add an existing datastore:
- edit "/etc/proxmox-backup/datastore.cfg"
```shell
datastore: backup
	gc-schedule daily
	keep-daily 1
	keep-last 1
	keep-monthly 5
	keep-weekly 5
	path /mnt/datastore/backup
	prune-schedule 2,22:30
```  

# Usefull tools:
Ioping - usefull to simulate drive activity and therefore locating it.

s-tui - Graphical interface to monitor system performances

stress - install it with s-tui to be able to stress your system - dont use in prod

