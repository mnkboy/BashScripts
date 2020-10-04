#!/bin/bash
echo -n "Introduzca el nombre del colegio"
echo ""
read NOMBRE

#Declaramos los nombres de las constantes a usar
PREFIX="./web"
POSTFIX="configuration.php"
RUTACOMPLETA=$PREFIX"/"$NOMBRE"/"$POSTFIX
NOMBREPHP="datos.php"
NOMBRETXT="datos.txt"
RUTADATOSPHP="./$NOMBREPHP"
RUTADATOSTXT="./$NOMBRETXT"

#Verificamos que exista el archivo datos.php
if [ -d $RUTADATOSPHP ]; then
    true
    else
        touch $RUTADATOSPHP
fi
#Verificamos que exista el archivo datos.txt
if [ -d $RUTADATOSPHP ]; then
    true
    else
        touch $RUTADATOSTXT
fi

#Si existe la ruta del archivo de configuraciones procedemos a extraer sus datos
if [ -e $RUTACOMPLETA ]; then
    echo "Se ha leido el nombre del colegio $NOMBRE"
    echo "" >$RUTADATOSPHP
    echo "<?php" >>$RUTADATOSPHP
    echo "\$fichero = 'datos.txt';" >>$RUTADATOSPHP
    echo  | awk ' NR==30 ' $RUTACOMPLETA >>$RUTADATOSPHP
    echo  | awk ' NR==32 ' $RUTACOMPLETA >>$RUTADATOSPHP
    echo  | awk ' NR==34 ' $RUTACOMPLETA >>$RUTADATOSPHP
    echo  | awk ' NR==36 ' $RUTACOMPLETA >>$RUTADATOSPHP
    echo  | awk ' NR==38 ' $RUTACOMPLETA >>$RUTADATOSPHP
    echo "echo \n\n"
    echo "  echo \"Este es el db_host: \".\$_configuration[\"db_host\"].\"\n\";"  >>$RUTADATOSPHP
    echo "  echo \"Este es el db_port: \".\$_configuration[\"db_port\"].\"\n\";"  >>$RUTADATOSPHP
    echo "  echo \"Este es el main_database: \".\$_configuration[\"main_database\"].\"\n\";"  >>$RUTADATOSPHP
    echo "  echo \"Este es el db_user: \".\$_configuration[\"db_user\"].\"\n\";"  >>$RUTADATOSPHP
    echo "  echo \"Este es el db_password: \".\$_configuration[\"db_password\"].\"\n\";"  >>$RUTADATOSPHP
    echo "echo \n\n"
    echo "  \$txt = \"============ PERMISOS $NOMBRE ============\n\";" >>$RUTADATOSPHP
    echo "  \$txt .= \"GRANT USAGE ON *.* TO '\".\$_configuration['db_user'].\"'@'\".\$_configuration['db_host'].\"' \n\";" >>$RUTADATOSPHP
    echo "  \$txt .= \"IDENTIFIED BY '\".\$_configuration['db_password'].\"' \n\";" >>$RUTADATOSPHP
    echo "  \$txt .= \"GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, REFERENCES, INDEX, \n\";" >>$RUTADATOSPHP
    echo "  \$txt .= \"ALTER, CREATE TEMPORARY TABLES, LOCK TABLES, EXECUTE, CREATE VIEW, SHOW VIEW, \n\";" >>$RUTADATOSPHP
    echo "  \$txt .= \"CREATE ROUTINE, ALTER ROUTINE, EVENT, TRIGGER ON '\".\$_configuration[\"main_database\"].\"'.* TO '\".\$_configuration[\"db_user\"].\"'@'\".\$_configuration['db_host'].\"'; \n\";" >>$RUTADATOSPHP
    echo "echo \n\n"
    echo "  \$txt .= \"============ MIGRACION $NOMBRE DB============\n\";" >>$RUTADATOSPHP
    echo "  \$txt .= \"mysqldump -h \".\$_configuration['db_host'].\" -u \".\$_configuration['db_user'].\" -p --\".\$_configuration['main_database'].\"  ceib > \".\$_configuration['main_database'].\".sql\n\";" >>$RUTADATOSPHP
    echo "  file_put_contents(\$fichero, \$txt, FILE_APPEND | LOCK_EX);" >>$RUTADATOSPHP
    echo "?>" >>$RUTADATOSPHP

    #Armamos los datos para las sentencias de permisos y migracion    
    php "$RUTADATOSPHP"
else
    echo "No existe la carpeta en la ruta $RUTACOMPLETA"    
fi

