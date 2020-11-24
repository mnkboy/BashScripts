# #!/bin/bash

#Definimos la ruta al archivo secret
file=$(pwd)'/ScriptSecret/secrets.txt'

#Verificamos si el archivo existe, si existe lo borramos
if [ -f $file ]; then
    rm $file
fi
#Imprimimos los encabezados
echo "==========================================================" >> $file
echo "Servidor   Secret" >> $file

#Iniciamos el ciclo que recorre la lista
for i in 1 11 12 2 21 22 23 24 25 26 27 28 3 31 32 33 34 35 36 4 41 6 7 8 9
    do    
        secret=$(openssl rand -hex 32)  #Generamos el secret
        server="bbb"$i".-  "$secret     #Concatenamos el server con el secret
        echo $server >> $file           #Lo agregamos al archivo
    done
echo "==========================================================" >> $file

cat $file                               #Imprimimos el archivo
