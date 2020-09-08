#!/bin/bash
echo -n "Introduzca un primer número: "; read x
echo -n "Introduzca un segundo número : "; read y
suma=$[$x + $y]
resta=$[$x - $y]
mul=$[$x * $y]
div=$[$x / $y]
mod=$[$x % $y]
# imprimimos las respuestas:
echo "Suma: $suma"
echo "Resta: $resta"
echo "Multiplicación: $mul"
echo "División: $div"
echo "Módulo: $mod"

# Esta es una comparacion de resultados de una suma
if [ $suma -gt 0 ]
    then
        echo "Es positiva la suma"
elif [ 0 -gt $suma ]
    then
        echo "Es negativa la suma"
else 
    echo "Es igual a cero"
fi