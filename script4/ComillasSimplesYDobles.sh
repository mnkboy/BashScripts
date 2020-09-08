#!/bin/bash

# Creamos una variable 
Var="Cadena de Prueba"

# Concatenamos variable con texto
NuevaVar="Valor de var es $Var"

echo $NuevaVar

#Las comllas simples mostraran una cadena de caracteres de forma literal sin resolucion de variables
var='cadena de prueba'
nuevavar='Valor de var es $var'
echo $nuevavar