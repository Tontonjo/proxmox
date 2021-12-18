# Tonton Jo - 2020
## Join me on Youtube: https://www.youtube.com/c/TontonJo

You'll find there some usefull commands used for proxmox

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
zpool upgrade "poolname"
```
## 5 - Monitoring

### 5.1 - Live disk IO
```shell
watch -n 1 "zpool iostat -v"
```
## 6 - Tools

Ioping - usefull to simulate drive activity and therefore locating it.

s-tui - Graphical interface to monitor system performances

stress - install it with s-tui to be able to stress your system - dont use in prod
