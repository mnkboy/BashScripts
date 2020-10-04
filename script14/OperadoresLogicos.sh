#!/bin/bash 
# !     //NOT
# -a    //AND  && <- Pero este no se usa dentro de corchetes
# -o    //OR   || <- Pero este no se usa dentro de corchetes
echo -n "Introduzca un número entre 1 < x < 10:"
read num


if [ "$num" -gt 1 -a "$num" -lt 10 ];
    then
        echo "$num*$num=[ $num*$num ]"
else
    echo "Número introducido incorrecto !"
fi

# Puede usarse || tambien como or, pero este no se puede usar dentro de corchetes
if [ "$num" -gt 0 ] || [ "$num" -lt 0 ]; then
    echo "El numero es distinto a cero"
else
    echo "El numero es cero"
fi