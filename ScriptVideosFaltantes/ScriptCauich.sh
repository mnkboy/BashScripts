#!/bin/bash
source "vars.env"
source "utils.sh"

listarArchivos () {
    find "$DIRECTORIO" $NO_RECURSIVO -type f  -newermt "$FECHA_INICIAL" ! -newermt "$FECHA_FINAL"
}

-----------------------------------------
#!/bin/bash
source "vars.env"
source "utils.sh"
source "1_ListarArchivos.sh"
arrayTest=$(listarArchivos)  
echo $arrayTest
# echo $arrayTest |
# while IFS= read -r -d '' file; do
#     item=${file//$DIRECTORIO"/"/ }      #limpiamos directorio orgen    
#     item="${item:1:${#item}-1}"         #quitamos el primer blancspace    
#     nombre=$DIRECTORIO_REMOTO"/"$item   #Concatenamos nombre    
    
#     eval "ls -la \"$nombre\" > /dev/null 2>&1"    #ejecutamos sin echo
#     resp=$(comprobar $?)
#     #evaluamos la respuesta
#     if [ resp > 0 ]; then                   
#         echo "El archivo no existe $resp $nombre"  
#         # array_name[$i]=$item
#         # ((i=i+1))
#     else
#         echo "El archivo existe $resp $nombre"                
#     fi            

    
#     # your code here
# done
# exit