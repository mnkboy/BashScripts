#!/bin/bash

# case $var in
# val1)
# instrucciones;;
# val2)
# instrucciones;;
# *)
# instrucciones;;
# esac

echo $1

case $1 in
    1) echo "valor de x es uno";;
    2) echo "valor de x es dos";;
    3) echo "valor de x es tres";;
    4) echo "valor de x es cuatro";;
    5) echo "valor de x es cinco";;
    6) echo "valor de x es seis";;
    7) echo "valor de x es siete";;
    8) echo "valor de x es ocho";;
    9) echo "valor de x es nueve";;
    0|10) echo "valor incorrecto";;
    *) echo "valor no reconocido";;
esac