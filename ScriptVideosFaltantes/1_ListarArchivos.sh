#!/bin/bash
source "utils.sh"

imprimir_encabezado "DEFINIMOS EL COMANDO"
COMANDO="find $DIRECTORIO $NO_RECURSIVO -type f  -newermt \"$FECHA_INICIAL\" ! -newermt \"$FECHA_FINAL\" | sed 's/ /**/g' "

imprimir_encabezado "IMPRIMIMOS LA LISTA"
LISTA=$(eval $COMANDO)
echo $LISTA

imprimir_encabezado "CHECAMOS LS -LA"
for item in $LISTA
    do
        # item="/home/javierjimenez/Escritorio/Aulas/Pasos_para_cambiar_el_nombre.txt"
        item=${item//"**"/\ }             #limpiamos
        eval "ls -la \"$item\""           #ejecutamos
    done

imprimir_encabezado "IMPRIMIMOS NOMBRE DE LOS ARCHIVOS"
for item in $LISTA
    do
        
        item=${item//"**"/\ }               #limpiamos        
        item=${item//$DIRECTORIO"/"/ }      #limpiamos                
        item=${item//$DIRECTORIO"/"/ }      #limpiamos                
        echo $item                          #mostramos el nombre del archivo
    done    