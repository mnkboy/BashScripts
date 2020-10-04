#!/bin/bash
# Comparación numérica:
#	-eq     //==
#	-ge     //>=
#	-le     //<=
#	-ne     //!=
#	-gt     //>
#	-lt     //<
# Ejemplos:
#	[ n1 -eq n2 ]
#	[ n1 -ge n2 ]
#	[ n1 -le n2 ]
#	[ n1 -ne n2 ]
#	[ n1 -gt n2 ]
#	[ n1 -lt n2 ]

echo -n "Introduzca un numero 1<x<10: "
echo ""
read num
if [ $num -ge 1 ]; then    
        if [ $num -lt 10 ]; then            
                echo "numero en rango: $num"
        else
            echo "Numero mayor a 10: $num"
        fi
    else
        echo "numero menor a 1: $num"
fi
