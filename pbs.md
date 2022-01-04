# Tonton Jo - 2020
## Join me on Youtube: https://www.youtube.com/c/TontonJo

You'll find there some usefull commands used for proxmox

## 1 - Proxmox Backup Server

### 1.1 - Add existing datastore / mountpoint
#### 1.1.1 - Identify / remount your datastore - for zpool: 
```shell
zfs get all | grep mountpoint
```  
```shell
mkdir -p /path/to/previous/$mountpoint
```  
#### 1.1.2 - edit /etc/proxmox-backup/datastore.cfg
```shell
datastore: $datastorename
        path /path/to/previous/$mountpoint
```  
