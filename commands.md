# Tonton Jo - 2022

You'll find there some usefull commands used for proxmox and more generally debian

## 1 - Proxmox

### 1.1 - Stop all services:  
```shell
for i in pve-cluster pvedaemon vz qemu-server pveproxy pve-cluster; do systemctl stop $i ; done
```  
## 2 - VM Management

### 2.1 - Disk passtrough
```shell
qm set VMID -scsi0 /dev/sdX
```
###  2.2 - Appliance Import
```shell
qm importdisk VMID pathtoappliance.ova local-lvm
```

###  2.3 - Appliance Export
- Identifiy the disk of a vm
```shell
qm config $vmid
```  
- Check absolute path ($absolutepath) for drive as seen by the OS
```shell
pvesm path local-lvm:vm-100-disk-0
```  
- Export the drive wanted: 
```shell
qemu-img convert -O qcow2 -f raw $absolutepath OUTPUT.qcow2
```  

## 3 - Disk Management

### 3.1 - Find a disc with ID:
```shell
ls /dev/disk/by-id/ -la
```
```shell
ls /dev/disk/by-id/ -la | grep "serial"
```

### 3.2 - list disk informations: Replace X
```shell
lsblk -o name,model,serial,uuid /dev/sdX
```
###  3.3 - find disk UUID or partition UUID
```shell
ls -l /dev/disk/by-uuid
```
```shell
ls -l /dev/disk/by-partuuid
```

### 3.4 - Wipe Disk
```shell
wipefs -af /dev/sdX
```
###  3.5 - Read actual partition status after change
```shell
hdparm -z /dev/sdX
```
```shell
echo 1 > /sys/block/sdX/device/rescan
```  
###  3.6 - Find the actual blocksize of all disks - Usually 4k
```shell
lsblk -o NAME,PHY-SeC
```

###  3.6 - Find the actual blocksize of all disks - Usually 4k
```shell
lsblk -o NAME,PHY-SeC
```
##  4 - Zpool Management  

###  4.1 - Remove import of removed pools at startup:  
####  4.1.1 - Identify your pools:
```shell
systemctl | grep zfs
```
#### 4.1.2 - Remove import of a pool at boot (remove old pools from load)
```shell
systemctl disable zfs-import@zpoolname.service
```

### 4.2 - Find ARC RAM usage for Zpool:
```shell
awk '/^size/ { print $1 " " $3 / 1048576 }' < /proc/spl/kstat/zfs/arcstats
```

### 4.3 - Find Compression ratio and used space:
```shell
zfs list -o name,avail,used,refer,lused,lrefer,mountpoint,compress,compressratio
``` 

### 4.4 - Replace Zpool Drive:
```shell
zpool replace pool /old/drive /new/drive
```

### 4.5 - Mark a pool as OK - Clear errors on pool and drives
```shell
zpool clear "poolname"
```

### 4.6 - Get Zpool version:
```shell
zpool --version
```

### 4.7 - Ugrade a zpool:
```shell
zpool upgrade "$poolname"
```  
### 4.8 - Zpool options settings
### 4.8.1 - Get your $poolname
```shell
zfs list
```
### 4.8.2 - find actual options - filter if necessary
```shell
zfs get all 
```
```shell
zfs get all | grep atime
```
### 4.8.3 - Set new option value
```shell
zfs set atime=off $poolname
```
```shell
zfs set compression=off $poolname
```  
### 4.9 - If pool is created with /dev/sdX instead of ID (wich may lead to mount fail)
```shell
zpool export $poolname
```  
```shell
zpool import -d /dev/disk/by-id -aN
```  
## 5 - Monitoring

### 5.1 - Live disk IO
```shell
watch -n 1 "zpool iostat -v"
```


Ioping - usefull to simulate drive activity and therefore locating it.

s-tui - Graphical interface to monitor system performances

stress - install it with s-tui to be able to stress your system - dont use in prod
