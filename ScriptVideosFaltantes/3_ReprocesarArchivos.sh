#!/bin/bash
source "utils.sh" 
source "vars.env"
source "2_ComprobarArchivos.sh" 

imprimir_encabezado "ESTAMOS EN 5_ReprocesadoReal"

# Almacenamos el array ejecutando la funcion
arrayTest=$(comprobarArchivos)

COMANDO="cd /usr/local/bigbluebutton/core/scripts"
echo $COMANDO

for item in $arrayTest
    do
        #ejecutamos sin echo
        COMANDO=`sudo -n -u bigbluebutton $RUTA_REPROCESO -m $item`
        resp=$(comprobar $?)
        
        #evaluamos la respuesta
        if [ $resp != "0" ]; then                   
            echo "El archivo no se reproceso $resp \"$item\". "
        else
            echo "El se ha reprocesado $resp \"$item\". "
        fi            
    done
