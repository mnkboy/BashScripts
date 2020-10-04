#!/bin/bash
# Una expresión puede ser: comparación de cadenas, comparación
# numérica, operadores de fichero y operadores lógicos y se representa
# mediante [expresión]:
# Comparación de cadenas:
#   =
#   !=
#   -n evalúa si la longitud de la cadena es superior a 0
#   -z evalúa si la longitud de la cadena es igual a 0
# Ejemplos:
#   [ s1 = s2 ] (true si s1 es igual a s2, sino false)
#   [ s1 != s2 ] (true si s1 no es igual a s2, sino false)
#   [ s1 ] (true si s1 no está vacía, sino false)
#   [ -n s1 ] (true si s1 tiene longitud mayor que 0, sino false)
#   [ -z s2 ] (true si s2 tiene longitud 0, sino false)

echo "Introduzca una cadena: ";
read x
echo "Introduzca otra cadena: ";
read y
echo "Cadena1: $x"
echo "Cadena2: $y"

if [ $x = $y ]
    then
        echo "Son iguales";
fi

if [ $x != $y ]
    then
        echo "Son diferentes";
fi

w="hola"
hf="tarolas"

# Como observacion es mejor evaluar cadena vacia con -z
if [ -z $w ]
    then
        echo "Esta vacia $w";
else
    echo "Cadena uno tiene contenido $w";    
fi

if [ -z $hf ]
    then
        echo "Esta vacia  $hf";
else
    echo "Cadena uno tiene contenido $hf";    
fi

# # Si no viene vacia entonces imprimimos el contenido
# if [ -n $w ]
#     then
#         echo "Cadena uno tiene contenido $w";
# else
#     echo "Cadena uno viene vacia";
# fi

# if [ -n $hf ]
#     then
#         echo "Cadena dos tiene contenido $hf";
# else
#     echo "Cadena dos viene vacia";
# fi

