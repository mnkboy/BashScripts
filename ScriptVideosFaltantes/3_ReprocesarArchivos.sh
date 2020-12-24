#!/bin/bash
source "utils.sh" 
source "vars.env"
source "2_ComprobarArchivos.sh" 

#Recibimos las fechas como parametros
FECHA_INICIAL=$1
FECHA_FINAL=$2

imprimir_encabezado "REPROCESADO DE ARCHIVOS"

# Almacenamos el array ejecutando la funcion
arrayTest=$(comprobarArchivos $FECHA_INICIAL $FECHA_FINAL)

#Cambiamos a la ruta de los scripts
cd /usr/local/bigbluebutton/core/scripts

#Recorremos el array para reprocesar los archivos
for item in $arrayTest
    do
        #ejecutamos sin echo
	    COMANDO=`sudo -n -u bigbluebutton $RUTA_REPROCESO -m $item`
        resp=$(comprobar $?)
        
        #evaluamos la respuesta
        if [ $resp != "0" ]; then                   
            echo "El archivo no se reproceso. \"$item\". "
            echo "Codigo de error: $resp"
        else
            echo "El archivo se ha reprocesado \"$item\". "
        fi            
    done
