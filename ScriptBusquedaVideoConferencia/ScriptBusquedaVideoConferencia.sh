#!/bin/bash

#Definimos la ruta al archivo de video conferencias
file=$(pwd)'/videoConferencia.txt'

#Pedimos el id de la conferencia
echo "Ingrese el id de la conferencia"

#Leemos el Id de la conferencia
read idConferencia

#Verificamos si el archivo existe, si existe lo borramos
if [ -f $file ]; then
    rm $file
fi

#Imprimimos los encabezados
echo "==========================================================" >> $file
echo "Servidor   Conferencia" >> $file

#Iniciamos el ciclo que recorre la lista
for i in 1 11 12 2 21 22 23 24 25 26 27 28 3 31 32 33 34 4 6 7 8 9 
    do
        #Creamos el comando
        comando="ssh bbb"$i".school-manager.education bbb-record --list | grep $idConferencia"  #Pedimos el Id de la conferencia
        #Ejecutamos el comando
        conferencia=$($comando)
        #Verificamos si existe informacion de la conferencia
        if [ ${#conferencia} -ge 5 ]
            then 
                server="bbb"$i".-  "$conferencia          #Si existe concatenamos la info de la conferencia
                echo $server
                echo $server >> $file                     #Agregamos la ip al archivo
                break;
            else 
                server="bbb"$i".-  No se encontro el ID $idConferencia"  #Si no existe concatenamos la info de la conferencia
                echo $server
                echo $server >> $file                     #Agregamos la ip al archivo
        fi
    done
echo "==========================================================" >> $file

cat $file                                                 #Imprimimos el archivo