# Proxmox

## Tonton Jo  
### Join the community:
[![Youtube](https://badgen.net/badge/Youtube/Subscribe)](http://youtube.com/channel/UCnED3K6K5FDUp-x_8rwpsZw?sub_confirmation=1)
[![Discord Tonton Jo](https://badgen.net/discord/members/h6UcpwfGuJ?label=Discord%20Tonton%20Jo%20&icon=discord)](https://discord.gg/h6UcpwfGuJ)
### Support my work, give a thanks and help the youtube channel:
[![Ko-Fi](https://badgen.net/badge/Buy%20me%20a%20Coffee/Link?icon=buymeacoffee)](https://ko-fi.com/tontonjo)
[![Infomaniak](https://badgen.net/badge/Infomaniak/Affiliated%20link?icon=K)](https://www.infomaniak.com/goto/fr/home?utm_term=6151f412daf35)
[![Express VPN](https://badgen.net/badge/Express%20VPN/Affiliated%20link?icon=K)](https://www.xvuslink.com/?a_fid=TontonJo)  
## Informations:  
This repository contains somes scripts and tips for Proxmox hypervisor and backup server

Find here [more of my videos about proxmox](https://www.youtube.com/playlist?list=PLU73OWQhDzsTfsnczSJWENIpZn1CNMzNP)

## Proxmox Toolbox - all-in-one setup tool!
If you want to setup and update your Proxmox VE / BS server, please have a look at my [Proxmox Toolbox](https://github.com/Tontonjo/proxmox_toolbox) 
- Set no subscription sources  
- New update command (proxmox-update) wich automatically remove message if needed  
- Security with Fail2ban  
- snmp  
- mail notifications  
- Backup and restoration of Proxmox VE / BS configurations

## CPU_SCALE
A home server may be power consuming and i wanted something to have a compromise between performance and energy saving without having to power-off the server
Here it is: [CPU_SCALE.SH](https://github.com/Tontonjo/proxmox/blob/master/cpu_scale.sh)  

- The script, when configured to start at boot or manually executed for testing purpose, will check for the cpu load and ramp-up to a better CPU Gouvernor when calculation power is needed.
- You can configure the ramp-up and ramp-down time
- You can choose what CPU gouvernor you want to use (i recommand switching between schedutil and powersave)

Here's a power consumption report for my server:  
![screenshot](https://i.ibb.co/F5R7qCx/Screenshot-2023-08-26-013402-Copy.png)  


# Usefull commands:
You'll find there some usefull commands used for proxmox and more generally debian

Menu:  
1 - Debian General  
1.1 - System  
1.2 - Drives Management  
1.3 - Zpool Management  
1.4 - Monitoring  
1.5 - PCI express  
1.6 - CPU  
1.7 - Benchmark and performance test  

2 - Proxmox Virtual Environement  
2.1 - Services management  
2.2 - Proxmox commands  
2.3 - VM Management  

3 - Proxmox Backup Server  
3.1 - Recover / add an existing datastore  

4 - Usefull tools  

# 1 - Debian General
## 1.1 - System  
### 1.1.1 - Date and time:  
```shell
dpkg-reconfigure tzdata
```
```shell
timedatectl set-ntp true
```
## 1.2 - Drives Management

### 1.2.1 - Find a disc with ID:
```shell
ls /dev/disk/by-id/ -la
```
```shell
ls /dev/disk/by-id/ -la | grep "serial"
```
### 1.2.2 - list disk informations: Replace X
```shell
lsblk -o name,model,serial,uuid /dev/sdX
```
###  1.2.3 - find disk UUID or partition UUID
```shell
ls -l /dev/disk/by-uuid
```
```shell
ls -l /dev/disk/by-partuuid
```

### 1.2.4 - Wipe Disk
```shell
wipefs -af /dev/sdX
```
### 1.2.5 - Read actual partition status after change
```shell
hdparm -z /dev/sdX
```
```shell
echo 1 > /sys/block/sdX/device/rescan
```  
###  1.2.6 - Find the actual blocksize of all disks - Usually 4k
```shell
lsblk -o NAME,PHY-SeC
```


##  1.3 - Zpool Management  
###  1.3.1 - Remove import of removed pools at startup:  
- Identify your pools:
```shell
systemctl | grep zfs
```
- Remove import of a pool at boot (remove old pools from load)
```shell
systemctl disable zfs-import@zpoolname.service
```
### 1.3.2 - Find ARC RAM usage for Zpool:
```shell
awk '/^size/ { print $1 " " $3 / 1048576 }' < /proc/spl/kstat/zfs/arcstats
```

### 1.3.3 - Find Compression ratio and used space:
```shell
zfs list -o name,avail,used,refer,lused,lrefer,mountpoint,compress,compressratio
``` 

### 1.3.4 - Replace Zpool Drive:
```shell
zpool replace pool /old/drive /new/drive
```

### 1.3.5 - Mark a pool as OK - Clear errors on pool and drives
```shell
zpool clear "poolname"
```

### 1.3.6 - Get Zpool version:
```shell
zpool --version
```

### 1.3.7 - Ugrade a zpool:
```shell
zpool upgrade "$poolname"
```  
### 1.3.8 - Zpool options settings
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
### 1.3.9 - If pool is created with /dev/sdX instead of ID (wich may lead to mount fail)
```shell
zpool export $poolname
```  
```shell
zpool import -d /dev/disk/by-id -aN
```  
## 1.4 - Monitoring

### 1.4.1 - ZFS live disk IO
```shell
watch -n 1 "zpool iostat -v"
```

##  1.5 - PCI express  
### 1.5.1 - Determine bus speed of a PCI-E Device ( and others infos if you remove the grep part )  
- Identify your device:
```shell
lspci
```  
- Get infos
```shell
lspci -vv -s 2a:00.0
```  
### 1.5.2 - Find IOMMU groups
#### An IOMMU group is the smallest set of physical devices that can be passed to a virtual machine  
```shell
#!/bin/bash
shopt -s nullglob
for g in $(find /sys/kernel/iommu_groups/* -maxdepth 0 -type d | sort -V); do
    echo "IOMMU Group ${g##*/}:"
    for d in $g/devices/*; do
        echo -e "\t$(lspci -nns ${d##*/})"
    done;
done;
```
##  1.6 - CPU
### 1.6.1 - Change CPU Gouvernor
#### Informations:
https://www.kernel.org/doc/Documentation/cpu-freq/governors.txt
#### Get actual CPU gouvernor
```shell
cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
```  
#### List availables CPU Gouvernors
```shell
cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors
```  
#### Apply CPU Gouvernor
```shell
echo "ondemand" | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
```  
#### Make CPU Governor reboot resilient
```shell
crontab -e
```  
```shell
@reboot echo "ondemand" | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor >/dev/null 2>&1
```  
## 1.7 - Benchmark and performance test
### 1.7.1 - Test with DD - oflag=dsync -> ignore cache for accurate result
```shell
dd if=/dev/zero of=/$pathtostorage/test1.img bs=1G count=1 oflag=dsync
```
### 1.7.2 - Test speed of drive (hdparm needed)
```shell
hdparm -t /dev/$sdX
```  
# 2 - Proxmox Virtual Environement  
## 2.1 - Services management  
### 2.1.1 - Stop all services:  
```shell
for i in pve-cluster pvedaemon vz qemu-server pveproxy pve-cluster; do systemctl stop $i ; done
```  
## 2.2 - Proxmox commands  
## 2.2.1 - Regenerate console login screen (usefull after ip changes)
```shell
pvebanner
```  
## 2.3 - VM Management  
### 2.3.1 - Disk passtrough  
```shell
qm set $vmid -scsi0 /dev/sdX
```  
###  2.3.2 - Appliance Import
#### If OVA: extract content
```shell
tar -xvf "path_to_appliance.ova"
```
```shell
qm importdisk $vmid path_to_appliance_disk.vmdk local-lvm
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

### 3.1 - Recover / add an existing datastore  
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
Ensure the rights are corrects:  
```shell
chown backup:backup -R "/path/to/datastore"
```

## 4 - Usefull tools
Ioping - usefull to simulate drive activity and therefore locating it.

s-tui - Graphical interface to monitor system performances

stress - install it with s-tui to be able to stress your system - dont use in prod

