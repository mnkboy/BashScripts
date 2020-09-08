#!/bin/bash

echo -n "Introduzca una variable de entrada"
echo ""
read variable
echo "Se ha leido esta variable $variable"
# Opciones
# – read –s (no hace echo de la entrda)
# – read –nN (acepta sólo N caracteres de entrada)
# – read –p “mensaje” (muestra un mensaje)
# – read –tT (acepta una entrada por un tiempo
#  máximo de T segundos)
read -s -n1 -p "si (S) o no (N)?" respuesta
echo ""
echo $respuesta