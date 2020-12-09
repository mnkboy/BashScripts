#!/bin/bash

#redimensionamos las particiones
lvresize --size +650G /dev/vg00/var && lvresize --size +100G /dev/vg00/home && lvresize --size +100G /dev/vg00/usr

#listamos las particiones redimensionadas
resize2fs /dev/vg00/var && resize2fs /dev/vg00/home && resize2fs /dev/vg00/usr && df -h

#Actualizamos el OS
apt update && apt upgrade -y

#Establecemos variables de configuracion
echo 'vm.overcommit_memory = 1' >> /etc/sysctl.conf
echo 'sysctl -w net.core.somaxconn=65535' >> /etc/rc.local

#Reiniciamos el servidor
reboot