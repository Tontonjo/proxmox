Information sur le fichier de configuration du deamon SMART:
https://linux.die.net/man/5/smartd.conf

Informations sur smartctl:
https://linux.die.net/man/8/smartctl

smartctl -a /dev/sdX
smartctl -H /dev/sdX

bits:
1   2   4    8    16    32      64      128
0   1   2    3     4    5       6        7

emplacement du fichier de configuration: /etc/smartd.conf
Configuration pour programmation des self-tests:
```
DEVICESCAN -d auto -n never -a -s (S/../../7/22|L/../01/./22) -m root -M exec /usr/share/smartmontools/smartd-runner
```  
```shell
service smartd restart
```
