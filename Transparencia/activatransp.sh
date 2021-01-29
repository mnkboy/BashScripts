#!/bin/bash
read -s -n2 -p "Porcentaje transparencia: " transp
echo $transp
ok=false
if [[ $transp =~ ^[0-9]+$ ]]
    then        
        ok=true
    else
        echo "Solo se permiten numeros"
        exit
fi

if [ $ok ]
    then
        if [ $transp -gt 99 ]
            then
                echo "ingrese un numero entre cero y 99"
                exit
        elif [ 10 -gt $transp ]
            then
                echo "No puede haber numeros menores a 10"
                exit
        else 
            sh -c 'xprop -f _NET_WM_WINDOW_OPACITY 32c -set _NET_WM_WINDOW_OPACITY $(printf 0x%x $((0xffffffff * '$transp' / 100)))'
            exit
        fi
fi