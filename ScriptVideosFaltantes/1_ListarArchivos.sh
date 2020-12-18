#!/bin/bash
source "utils.sh"
source "vars.env"

listarArchivos () {
    # imprimir_encabezado "DEFINIMOS EL COMANDO"
    COMANDO="find '$DIRECTORIO' $NO_RECURSIVO -type f  -newermt \"$FECHA_INICIAL\" ! -newermt \"$FECHA_FINAL\" | sed 's/ /$COMODIN/g' "

    # imprimir_encabezado "IMPRIMIMOS LA LISTA"
    LISTA=$(eval $COMANDO)
    # echo $LISTA

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
    echo "${array_name[*]}"
}