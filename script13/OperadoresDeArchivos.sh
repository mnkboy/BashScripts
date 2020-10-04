#!/bin/bash

#	-d verifica si el path dado es un directorio
#	-f verifica si el path dado es un archivo
#	-s verifica si el path dado en un link simbólico
#	-e verifica si el fichero existe
#	-s verifica si el fichero tiene un tamaño mayor a 0
#	-r verifica si el fichero tiene permiso de lectura
#	-w verifica si el fichero tiene permiso de escritura
#	-x verifica si el fichero tiene permiso de ejecución

RUTA="/home/mnkboy/Escritorio/ProyectosGit/BashScripts/script"
NUM=11
FILE=vacio
RUTACOMPLETA=$RUTA$NUM"/"$FILE

if [ -d $RUTACOMPLETA ]; then
    echo "Existe la carpeta en la ruta $RUTACOMPLETA"
else
    echo "No existe la carpeta en la ruta $RUTACOMPLETA"    
fi


if [ -f $RUTACOMPLETA ]; then
    echo "Es un archivo $RUTACOMPLETA"
    if [ -e $RUTACOMPLETA ]; then
            echo "Existe el archivo en la ruta $RUTACOMPLETA"
            if [ -s $RUTACOMPLETA ];then
                echo "el archivo tiene peso $RUTACOMPLETA"
                    if [ -r $RUTACOMPLETA ]; then
                        echo "El archivo tiene permisos de lectura" 
                        elif [ -w $RUTACOMPLETA ];then
                            echo "El archivo tiene permisos de escritura" 
                        elif [-x $RUTACOMPLETA ];then
                            echo "El archivo tiene permisos de ejecucion" 
                    else
                        echo "El archivo no tiene permisos de escritura lectura o ejecucion"
                    fi
            else
                echo "el archivo no pesa $RUTACOMPLETA"
                if [ -r $RUTACOMPLETA ]; then
                        echo "El archivo no tiene permisos de lectura"
                        elif [ -w $RUTACOMPLETA ];then
                            echo "El archivo no tiene permisos de escritura"
                        elif [-x $RUTACOMPLETA ];then
                            echo "El archivo no tiene permisos de ejecucion"
                    else
                        echo "El archivo no tiene permisos de escritura lectura o ejecucion"
                    fi
            fi

        else
            echo "No existe el archivo en la ruta $RUTACOMPLETA"
    fi    

else
    echo "No existe el archivo en la ruta $RUTACOMPLETA"    
fi

