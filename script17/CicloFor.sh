#!/bin/bash

#   for var in lista
#   do
#       statements
#   done

let sum=0
for num in 1 2 3 4 5; 
    do    
        let "sum = $sum + $num"
    done
echo $sum


for x in papel lapiz boli; 
    do
        echo "El valor de la variable x es: $x"
        sleep 1
    done

for x in "papel a4" "lapiz STADTLER" "boli BIC"; 
    do
        echo "El valor de la variable x es: $x"
    sleep 1
    done

lista="antonio luis maria pepa"    

for x in $lista;
    do
        echo "El valor de la variable x es: $x"
        sleep 1
    done

# Listamos todos los ficheros del directorio actual

# for x in ../* <--- Si queremos ver el directorio superior
# for x in /bin <--- Si queremos ver el directorio bin
 for x in *
    do
        ls -l "$x"
        sleep 1
    done

read -p "introduzca el nombre de un directorio: " directorio

echo directorio

echo "Enlaces simbolicos en el directorio $directorio"

for fichero in $(find $directorio -type l)
    do 
        echo "$fichero"
    done
    
