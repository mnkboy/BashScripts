#!/bin/bash

function check(){
    if [ -e "/home/mnkboy/$1" ]
    then
        return 0
    else
        return 1
    fi
}

echo "Introduzca el nombre del archivo: ";
read x

if check $x
    then echo "$x existe !"
else
    echo "$x no existe !"
fi