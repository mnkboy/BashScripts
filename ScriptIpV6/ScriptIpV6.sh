# #!/bin/bash

#Definimos la ruta al archivo secret
file=$(pwd)'/ipv6.txt'

#Verificamos si el archivo existe, si existe lo borramos
if [ -f $file ]; then
    rm $file
fi

#Imprimimos los encabezados
echo "==========================================================" >> $file
echo "Servidor   IpV6" >> $file

#Iniciamos el ciclo que recorre la lista
for i in 1 11 12 2 21 22 23 24 25 26 27 28 3 31 32 33 34 4 6 7 8 9
    do
        ipv6="ssh bbb"$i".school-manager.education cat /etc/nginx/conf.d/bigbluebutton_sip_addr_map.conf | grep \"::\""  #Pedimos la IPv6
        ip=$($ipv6)                 #limpiamos el string de la ip
        ip=${ip//\"~:\"/ }          #limpiamos
        ip=${ip//"["/ }             #limpiamos
        ip=${ip//"];"/ }            #limpiamos
        server="bbb"$i".-  "$ip     #Concatenamos el server con la ip limpia
        echo $server >> $file       #Agregamos la ip al archivo
    done
echo "==========================================================" >> $file

cat $file                           #Imprimimos el archivo