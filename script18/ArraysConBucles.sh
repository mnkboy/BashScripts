#!/bin/bash

# Crear un array 
#     mascota[0]=perro
#     mascota[1]=gato
#     mascota[2]=pez
#     pet=(perro gato pez)
# Longitud Longitud maxima de un array son 1024 elementos
# Para extraer una entrada del array ${array[i]}

# Declaramos los arrays
mascota[0]=perro
mascota[1]=gato
mascota[2]=pez
pet=(gato perro pez)

echo ${mascota[0]}
echo ${mascota[2]}

echo ${pet[1]}

# Para extraer todos los elementos de un array se utiliza asterisco
echo ${mascota[*]}
echo ${#mascota[*]}

# Podemos combinar los arrays con bucles utilizando
for x in ${mascota[*]}
    do
        echo ${mascota[$x]}
    done

echo "Introduzca un numero: "; 
read x
let sum=0

# bucle tipo C
for ((i=1;$i<$x;i=$i+1));do
        let "sum = $sum + $i"        
    done
echo "La suma de los primeros $x numeros es: $sum"

# Bucle tipo C para array
for ((i=0;$i<${#mascota[*]};i=$i+1));do
        echo ${mascota[i]}
    done







