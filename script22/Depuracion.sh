#!/bin/bash -x

# Bash ofrece dos formas de depurar los shell scripts
# -v : muestra cada línea completa del script antes de ser ejecutada
# -x : muestra cada línea abreviada del script antes de ser ejecutada
# Uso: #!/bin/bash –v, o #!/bin/bash –x
echo -n "Introduzca un  numero: ";
read x

let sum=0
for ((i=1; $i<$x; i=$i+1));
    do
        let "sum = $sum + $i"
    done
echo "la suma de los $x primeros numeros es: $sum"