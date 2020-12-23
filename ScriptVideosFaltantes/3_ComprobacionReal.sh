#!/bin/bash
source "vars.env"


ssh bbb12.school-manager.education find /var/bigbluebutton/published/presentation -maxdepth 1 -type f  -newermt "2020-12-16 10:17:00" ! -newermt "2020-12-23 10:17:00" 

# imprimir_encabezado "DEFINIMOS EL COMANDO"
# COMANDO="ssh $SERVIDOR ls /var/bigbluebutton/published/presentation"

# COMANDO="find '$DIRECTORIO' $NO_RECURSIVO -type f  -newermt \"$FECHA_INICIAL\" ! -newermt \"$FECHA_FINAL\" | sed 's/ /$COMODIN/g' "

# # imprimir_encabezado "IMPRIMIMOS LA LISTA"
# LISTA=$(eval $COMANDO)
# echo $LISTA

# ssh scalelite-spool@records.school-manager.education ls /var/scalelite-recordings/var/bigbluebutton/published/presentation | grep "51542fcc6a1f4361f139923f9ebee93a427a3c82-1607733612500"

ssh bbb12.school-manager.education find "/var/bigbluebutton/published/presentation" -maxdepth 1 -type d  -newermt '2020-12-22T10:17:00' ! -newermt '2020-12-23T10:17:00' 