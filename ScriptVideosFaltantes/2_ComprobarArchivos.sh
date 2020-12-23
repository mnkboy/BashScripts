#!/bin/bash
source "utils.sh" 
source "vars.env"
source "1_ListarArchivos.sh" 
# Llamamos a la funcion que nos trae el nombre de los archivos
imprimir_encabezado "Estamos en 2_VerificarExisteArchivo.sh"

#Almacenamos el array ejecutando la funcion
arrayTest=$(listarArchivos)  

#Verificamos que existan los elementos de la lista
imprimir_encabezado "CHECAMOS LS -LA"

#Declaramos un array
declare -A array_name
i=0
for item in $arrayTest
        do            
            nombre=${item//"$COMODIN"/\ }                  #limpiamos
            nombre="$DIRECTORIO_REMOTO/$nombre"            #limpiamos             
            eval "ls -la \"$nombre\" > /dev/null 2>&1"     #ejecutamos sin echo
            resp=$(comprobar $?)

            #evaluamos la respuesta
            if [ $resp != "0" ]; then                   
                echo "El archivo no existe $resp \"$nombre\" "  
                array_name[$i]=$item
                ((i=i+1))
            else
                echo "El archivo existe $resp \"$nombre\" "
            fi            
    done
imprimir_encabezado "Elementos inexistentes"

#Obtenemos el largo del array
len=${#array_name[@]}
 

#Imprimimos elementos inexistentes
for (( i=0; i<$len; i++ )); 
    do 
        echo "${array_name[$i]}" ; 
    done