#!/bin/bash

# Parámetros especiales
# $# número de parámetros pasados
# $0 devuelve el nombre del shell script que se está ejecutando y su ubicación en el sistema de archivos
# $* devuelve en una cadena de caracteres todos los parámetros pasados al script
# $@ devuelve un array con los parámetros pasados al scrip


echo "$#: $0; $1; $2; $*; $@"
