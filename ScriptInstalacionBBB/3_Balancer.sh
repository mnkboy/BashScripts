#!/bin/bash
#Add Server
#En la variable NOMBRE_SERVIDOR se pone el nombre de servidor Y en SECRET se pone el secret
NOMBRE_SERVIDOR="bbb34.school-manager.education" && SECRET="eb1eedaba03e0f5fe4c8520deb8d6e2ddcd7bbeaa9a73cfcfcde90a1926d47e1" && bbb-add  https://$NOMBRE_SERVIDOR/bigbluebutton/api $SECRET 1

#Enable Server
#En la variable nombre de servidor se pone el nombre de servidor
NOMBRE_SERVIDOR="bbb24.school-manager.education" && uuid=`bbb-list | grep -B 1 -A 5 $NOMBRE_SERVIDOR | grep "id:" | sed 's/id:\ //'` && bbb-enable $uuid && bbb-poll


#Disable Server
NOMBRE_SERVIDOR="bbb8.school-manager.education" && uuid=`bbb-list | grep -B 1 -A 5 $NOMBRE_SERVIDOR | grep "id:" | sed 's/id:\ //'` && bbb-disable $uuid && bbb-poll

#Remove Server
NOMBRE_SERVIDOR="bbb8.school-manager.education" && uuid=`bbb-list | grep -B 1 -A 5 $NOMBRE_SERVIDOR | grep "id:" | sed 's/id:\ //'` && bbb-remove $uuid && bbb-poll