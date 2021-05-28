# Tonton Jo - 2020
# Join me on Youtube: https://www.youtube.com/c/TontonJo

You'll find there some usefull commands used for proxmox

## Proxmox

### Stop all services:  
for i in pve-cluster pvedaemon vz qemu-server pveproxy pve-cluster; do systemctl stop $i ; done

---------------------- VM Management --------------------------------

### Disk passtrough

qm set VMID -scsi0 /dev/sdX

Appliance Import

qm importdisk VMID pathtoappliance.ova local-lvm


---------------------- Disk management ------------------------------


### Find a disc with ID:

ls /dev/disk/by-id/ -la

ls /dev/disk/by-id/ -la | grep "serial"


### list disk informations: Replace X

lsblk -o name,model,serial,uuid /dev/sdX


### Read actual partition status after change

hdparm -z /dev/sdX

----------------------Zpool Management ------------------------------


### Find ARC RAM usage for Zpool:

awk '/^size/ { print $1 " " $3 / 1048576 }' < /proc/spl/kstat/zfs/arcstats


### Replace Zpool Drive:

zpool replace pool /old/drive /new/drive


### mark a pool a OK - Clear errors on pool and drives

zpool clear "poolname"


### Get Zpool version:

zpool --version


### ugrade a zpool:

zpool upgrade "poolname"

---------------------- MONITORING ----------------------------------

### live disk IO

watch -n 1 "zpool iostat -v"

-------------------------- TOOLS --------------------------------------

Ioping - usefull to simulate drive activity and therefore locating it.

s-tui - Graphical interface to monitor system performances

stress - install it with s-tui to be able to stress your system - dont use in prod
