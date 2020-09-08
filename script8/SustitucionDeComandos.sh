#!/bin/bash
# El símbolo "`" tiene un uso diferente de "´". Se utiliza para sustitución de
# instrucciones. Es decir si dentro de un script aparece el texto "`comando`"
# entonces se ejecutará lo orden que està entre las "`"

LISTA=`ls`

echo $LISTA # Lista los archivos

# Otra forma de realizar la sustitución de comandos: $(comando)
DirActual=$(pwd)
echo $DirActual

