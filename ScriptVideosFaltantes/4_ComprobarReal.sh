#!/bin/bash
source "utils.sh" 
source "vars.env"
source "3_ListarReal.sh" 

comprobarArchivos () {
     #Almacenamos el array ejecutando la funcion
    arrayTest=$(listarArchivos)
    
    # #Declaramos un array
    declare -A array_name
    i=0
    for item in $arrayTest
            do
                #ejecutamos sin echo
                eval "ssh $SERVIDOR_REMOTO ls $DIRECTORIO_REMOTO | grep $item > /dev/null 2>&1"     
                resp=$(comprobar $?)
                
                #evaluamos la respuesta
                if [ $resp != "0" ]; then                   
                    # echo "El archivo no existe $resp \"$item\" "  
                    array_name[$i]=$item
                    ((i=i+1))                
                fi            
        done    

    #Obtenemos el largo del array
    len=${#array_name[@]}
    
    #Imprimimos elementos inexistentes
    echo ${array_name[*]}
}