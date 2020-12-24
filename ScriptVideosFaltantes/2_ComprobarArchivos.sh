#!/bin/bash
source "utils.sh" 
source "vars.env"
source "1_ListarArchivos.sh" 

#Recibimos las fechas como parametros
FECHA_INICIAL=$1
FECHA_FINAL=$2

comprobarArchivos () {
    #Almacenamos el array ejecutando la funcion
    arrayTest=$(listarArchivos $FECHA_INICIAL $FECHA_FINAL)

    #Primero traemos la lista de directorios de records
    eval "sudo -n -u $USUARIO_BBB ssh $SERVIDOR_REMOTO ls $DIRECTORIO_REMOTO > $RUTA_LISTA_VIDEOS"
    resp=$(comprobar $?)
    
    #Declaramos un array
    declare -A array_name
    i=0
    for item in $arrayTest
            do
		#ejecutamos sin echo                
                c=`grep -c $item $RUTA_LISTA_VIDEOS`
                
		#evaluamos la respuesta
                if [ $c != "1" ]; then                   
                    #echo "El archivo no existe $resp \"$item\" "  
                    array_name[$i]=$item
                    ((i=i+1))                
                fi            
        done    

    #Obtenemos el largo del array
    len=${#array_name[@]}
    
    #Imprimimos elementos inexistentes
    echo ${array_name[*]}
}
