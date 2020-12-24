#!/bin/bash
source "vars.env"

listarArchivos () {
    LISTA=`ssh $SERVIDOR find $DIRECTORIO $NO_RECURSIVO $TIPO_ARCHIVO  -newermt $FECHA_INICIAL ! -newermt $FECHA_FINAL`

    #Declaramos un array
    declare -A array_name
    i=0

    # imprimir_encabezado "IMPRIMIMOS NOMBRE DE LOS ARCHIVOS"
    for item in $LISTA
        do  
            item=${item//$DIRECTORIO"/"/ }      #limpiamos                            
            array_name[$i]=$item
            ((i=i+1))
        done
    #Imprimimos archivos que vamos a buscar
    echo "${array_name[*]}"
}