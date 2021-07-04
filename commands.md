# Tonton Jo - 2020
## Join me on Youtube: https://www.youtube.com/c/TontonJo

You'll find there some usefull commands used for proxmox

## Proxmox

### Stop all services:  
```shell
for i in pve-cluster pvedaemon vz qemu-server pveproxy pve-cluster; do systemctl stop $i ; done
```

## VM Management

### Disk passtrough
```shell
qm set VMID -scsi0 /dev/sdX
```
Appliance Import
```shell
qm importdisk VMID pathtoappliance.ova local-lvm
```

## Disk Management

### Find a disc with ID:
```shell
ls /dev/disk/by-id/ -la
```
```shell
ls /dev/disk/by-id/ -la | grep "serial"
```

### list disk informations: Replace X
```shell
lsblk -o name,model,serial,uuid /dev/sdX
```

### Read actual partition status after change
```shell
hdparm -z /dev/sdX
```
## Zpool Management  


### Find ARC RAM usage for Zpool:
```shell
awk '/^size/ { print $1 " " $3 / 1048576 }' < /proc/spl/kstat/zfs/arcstats
```

### Find Compression ratio and used space:
```shell
zfs list -o name,avail,used,refer,lused,lrefer,mountpoint,compress,compressratio
``` 

### Replace Zpool Drive:
```shell
zpool replace pool /old/drive /new/drive
```

### mark a pool a OK - Clear errors on pool and drives
```shell
zpool clear "poolname"
```

### Get Zpool version:
```shell
zpool --version
```

### ugrade a zpool:
```shell
zpool upgrade "poolname"
```
## Monitoring

### live disk IO
```shell
watch -n 1 "zpool iostat -v"
```
## Tools

Ioping - usefull to simulate drive activity and therefore locating it.

s-tui - Graphical interface to monitor system performances

stress - install it with s-tui to be able to stress your system - dont use in prod
