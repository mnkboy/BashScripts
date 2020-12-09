#!/bin/bash
#========================================================
#============== VARIABLES DE CONFIGURACION ==============
#========================================================
source "vars.env"

#===========================================================
#===========================================================
#======================== FUNCIONES ========================
#===========================================================

#Funcion para separar bloques de codigo
funcion_header () {
    echo;
    echo "============================================";
    echo "============================================";
}

#Declaramos una funcion para confirmar los nombres
funcion_confirmacion () {
    echo "Indique \"s\" o \"n\" y enter"

    #leemos la confirmacion
    read c

    #Validamos la confirmacion
    while [ $c != "s" ]; 
    do
        echo;
        echo "$1 Es correcto ? pulse \"s\" y enter."
        echo "De lo contrario finalice pulsando \"n\" y enter."        
        read -s c
        if [ $c == "n" ]
            then
                echo "El nombre no es el correcto. Terminamos."
                exit false
            else                
                echo;
        fi
    done
    echo "El nombre $1 es correcto. Continuamos ..."
}

#======================================================
#======================== MAIN ========================
#======================================================

#------------------------------------------------------------
#Confirmamos nombre del servidor nuevo
funcion_header
echo "El nombre del servidor es correcto: \"$NOMBRE_SERVIDOR_NUEVO\" ?"
funcion_confirmacion $NOMBRE_SERVIDOR_NUEVO


#Concatenamos los parametros del comando
comando="wget https://ubuntu.bigbluebutton.org/bbb-install.sh && chmod +x bbb-install.sh && ./bbb-install.sh -v xenial-22 -s $NOMBRE_SERVIDOR_NUEVO"

#imprimimos el comando
echo $comando

#------------------------------------------------------------
#Pedimos nombre del servidor de copia de archivos
funcion_header
echo "Indique si el nombre del servidor de copia es correcto: $SERVIDOR_COPIA s/n"
funcion_confirmacion $SERVIDOR_COPIA


#------------------------------------------------------------
# #Pedimos nombre del usuario de copia 
funcion_header
echo "Indique si el nombre del usuario de copia es correcto: $USUARIO_COPIA s/n"
funcion_confirmacion $USUARIO_COPIA


#------------------------------------------------------------
#Eliminamos el instalador y copiamos ssl
funcion_header
comando="rm bbb-install.sh && mkdir /etc/nginx/ssl && scp $USUARIO_COPIA@$SERVIDOR_COPIA:~/bbb.school-manager.education/* /etc/nginx/ssl"
echo $comando

#------------------------------------------------------------
#Copiamos 
funcion_header
comando="scp $USUARIO_COPIA@$SERVIDOR_COPIA:~/favicon.png  /var/www/bigbluebutton-default/images/favicon.png"
echo $comando
comando="scp $USUARIO_COPIA@$SERVIDOR_COPIA:~/favicon.ico  /var/www/bigbluebutton-default/favicon.ico"
echo $comando
comando="scp $USUARIO_COPIA@$SERVIDOR_COPIA:~/default.pdf  /var/www/bigbluebutton-default/default.pdf"
echo $comando

#Copiamos
funcion_header
comando="cp -p /etc/nginx/sites-available/bigbluebutton /root/"
echo $comando

#------------------------------------------------------------
#Edicion de archivos
funcion_header
comando="sed -i '5i listen 443 ssl;' /etc/nginx/sites-available/bigbluebutton"
echo $comando
comando="sed -i '6i listen [::]:443 ssl;' /etc/nginx/sites-available/bigbluebutton"
echo $comando
comando="sed -i '7i ssl_certificate /etc/nginx/ssl/fullchain.pem;' /etc/nginx/sites-available/bigbluebutton"
echo $comando
comando="sed -i '8i ssl_certificate_key /etc/nginx/ssl/privkey.pem;' /etc/nginx/sites-available/bigbluebutton"
echo $comando
comando="sed -i '9i ssl_session_cache shared:SSL:10m;' /etc/nginx/sites-available/bigbluebutton"
echo $comando
comando="sed -i '10i ssl_protocols TLSv1 TLSv1.1 TLSv1.2;' /etc/nginx/sites-available/bigbluebutton"
echo $comando
comando="sed -i '11i ssl_ciphers \"ECDH+AESGCM:DH+AESGCM:ECDH+AES256:DH+AES256:ECDH+AES128:DH+AES:ECDH+3DES:DH+3DES:RSA+AESGCM:RSA+AES:RSA+3DES:!aNULL:!MD5:!DSS:!AES256\";' /etc/nginx/sites-available/bigbluebutton"
echo $comando
comando="sed -i '12i ssl_prefer_server_ciphers on;' /etc/nginx/sites-available/bigbluebutton"
echo $comando
comando="sed -i '13i ssl_dhparam /etc/nginx/ssl/dhp-4096.pem;' /etc/nginx/sites-available/bigbluebutton"
echo $comando

#------------------------------------------------------------
funcion_header
#IPv4
comando="ip addr | grep \"inet\" | grep \"/32\" | sed 's/\/32.*//' | sed 's/\/32//' | sed 's/\inet\ //'"
echo $comando
#IPv6
comando="ip addr | grep \"inet6\" | grep \"/64\" | sed 's/\/64.*//' | sed 's/\/64//' | sed 's/\inet6\ //'"
echo $comando