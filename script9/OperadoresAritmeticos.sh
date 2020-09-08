#!/bin/bash
# Operadores aritméticos
# + suma
# - resta
# * multiplicación
# / división
# ** exponenciación
# % módulo

# La instrucción let se puede utilizar para realizar funciones matemáticas:
# – $ let X=10+2*7
# $ echo $X
# 24
# $ let Y=X+2*4
# $ echo $Y
# 32
# Un expresión aritmética se puede evaluar con $[expression] o
# $((expression))
# – $ echo $((123+20))
# 143
# – $ VALOR=$[123+20]
# – $ echo $[123*$VALOR]
# 1430
# – $ echo $[2**3]
# – $ echo $[8%3]

a=$[(5+2)*3]
echo $a
b=$[2**3]
echo $[$a+$b]