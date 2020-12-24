#!/bin/bash
source "utils.sh" 
source "vars.env"
source "2_ComprobarArchivos.sh" 

imprimir_encabezado "REPROCESADO DE ARCHIVOS"

# Almacenamos el array ejecutando la funcion
arrayTest=$(comprobarArchivos)

#Cambiamos a la ruta de los scripts
cd /usr/local/bigbluebutton/core/scripts

#Recorremos el array para reprocesar los archivos
for item in $arrayTest
    do
        #ejecutamos sin echo
        COMANDO=`sudo -n -u bigbluebutton $RUTA_REPROCESO -m $item`
        echo $COMANDO
        resp=$(comprobar $?)
        
        #evaluamos la respuesta
        if [ $resp != "0" ]; then                   
            echo "El archivo no se reproceso $resp \"$item\". "
        else
            echo "El se ha reprocesado $resp \"$item\". "
        fi            
    done
