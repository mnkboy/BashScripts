#!/bin/bash
#========================================================
#============== VARIABLES DE CONFIGURACION ==============
#========================================================
source "vars.env"

#===========================================================
#===========================================================
#======================== FUNCIONES ========================
#===========================================================
continuar () {
    read -s -n 1 -t 2 c
}

#Comprobamos si el comando ejecutado tuvo algun error
comprobar () {
    local output=$1
    if [ $output -ne 0 ]; then
        echo "Ocurrio un error."
        exit $output
    fi
    echo "0"
}
#Recibimos un comando en texto para ejecutar
ejecutar () {    
    local comando=$1
    if [ "$TEST" = true ] ; then
        echo $comando
        return 
    fi

    #Ejecutamos el comando
    eval $comando
    comprobar $?
}

#Funcion para separar bloques de codigo
imprimir_encabezado () {
    echo;    
    echo "======================$1======================";
    echo;        
}

#Declaramos una funcion para confirmar los nombres
confirmar () {    
    c="n" #Por defecto es diferente de "s"
    #Validamos la confirmacion
    while [ $c != "s" ] 
    do        
        echo;
        read -s -n 1 -p "$1. Pulse [s]i [n]o." c
        if [ $c == "n" ];then
            exit 1            
        fi
    done
    echo;
    echo "Continuamos ..."
    echo;
}