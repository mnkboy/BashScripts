#!/bin/bash
source "vars.env"

#Recibimos las fechas como parametros
FECHA_INICIAL=$1
FECHA_FINAL=$2

listarArchivos () {
    #Tomamos la fecha actual, que sera la final
    fechaFinal=`printf '%(%Y-%m-%d)T\n' -1`    

    #Le restamos dos dias y ya es la fecha inicial
    fechaInicial=$(date -d "$fechaFinal -$DIAS days" +"%Y-%m-%d")    

    #Formateamos la fecha
    fechaInicial=$fechaInicial"T00:00:00"
    fechaFinal=$fechaFinal"T00:00:00"
    
    #Verificamos si las fechas estan vacias
    if [ -z $FECHA_INICIAL ]; then   
        FECHA_INICIAL=$fechaInicial
    fi            
    
    #Verificamos si las fechas estan vacias
    if [ -z $FECHA_FINAL ]; then
        FECHA_FINAL=$fechaFinal
    fi

    #Ejecutamos el comando
    LISTA=`find $DIRECTORIO $NO_RECURSIVO $TIPO_ARCHIVO  -newermt $FECHA_INICIAL ! -newermt $FECHA_FINAL`

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
