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
    echo "Indique [s]i o [n]o y enter"

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
#Creamos ruta de archivos prueba
RUTA_PRUEBAS_LOCAL=$(pwd)'/'$RUTA_PRUEBAS

#Creamos la carpeta de pems
if [ -d $RUTA_PRUEBAS_LOCAL ]; then
    echo "Existe la carpeta de $RUTA_PRUEBAS en la ruta:"
    echo  $RUTA_PRUEBAS_LOCAL
else
    echo "No existe la carpeta en la ruta $RUTA_PRUEBAS"
    echo "Se creara la carpeta $RUTA_PRUEBAS"
    mkdir -p $RUTA_PRUEBAS_LOCAL
fi

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
#Obtenemos IPv4 e IPv6
funcion_header
#IPv4
IPv4=`ip addr | grep "inet" | grep "/32" | sed 's/\/32.*//' | sed 's/\/32//' | sed 's/\inet\ //'`
echo $IPv4
#IPv6
IPv6=`ip addr | grep "inet6" | grep "/64" | sed 's/\/64.*//' | sed 's/\/64//' | sed 's/\inet6\ //'`
echo $IPv6

#------------------------------------------------------------
#Agregamos IPv4 e IPv6 al archivo
echo $RUTA_PRUEBAS_LOCAL
cat > $RUTA_PRUEBAS_LOCAL'/'bigbluebutton_sip_addr_map.conf <<EOF
map \$remote_addr \$freeswitch_addr {
    "~:"    [$IPv6];
    default    $IPv4;
}
EOF

#------------------------------------------------------------
#Creamos archivo $freeswitch
cat > $RUTA_PRUEBAS_LOCAL'/'sip.nginx << EOF
location /ws {
        proxy_pass https://\$freeswitch_addr:7443;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection "Upgrade";
        proxy_read_timeout 6h;
        proxy_send_timeout 6h;
        client_body_timeout 6h;
        send_timeout 6h;

        auth_request /bigbluebutton/connection/checkAuthorization;
        auth_request_set \$auth_status \$upstream_status;
}
EOF

cat $RUTA_PRUEBAS_LOCAL'/'sip.nginx

#--------------------------------------------------
comando="sed -i 's/worker_connections 768/worker_connections 6000/g' /etc/nginx/nginx.conf"
echo $comando
comando="sed -i 's/30m/150m/g' /etc/bigbluebutton/nginx/web.nginx "
echo $comando
comando="sed -i 's/maxFileSizeUpload=30000000/maxFileSizeUpload=150000000/g'  /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties "
echo $comando
comando="sed -i 's/uploadSizeMax: 50000000/uploadSizeMax: 150000000/g' /usr/share/meteor/bundle/programs/server/assets/app/config/settings.yml "
echo $comando
comando="sed -i 's/bigbluebutton.web.serverURL=http/bigbluebutton.web.serverURL=https/g' /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties"
echo $comando
comando="sed -i 's/jnlpUrl=http/jnlpUrl=https/g' /usr/share/red5/webapps/screenshare/WEB-INF/screenshare.properties"
echo $comando
comando="sed -i 's/jnlpFile=http/jnlpFile=https/g' /usr/share/red5/webapps/screenshare/WEB-INF/screenshare.properties"
echo $comando
comando="sed -e 's|http://|https://|g' -i /var/www/bigbluebutton/client/conf/config.xml"
echo $comando
comando="sed -i 's/url: http\:\/\//url: https\:\/\//g' /usr/share/meteor/bundle/programs/server/assets/app/config/settings.yml"
echo $comando
comando="sed -i 's/wsUrl: ws\:/wsUrl: wss\:/g' /usr/share/meteor/bundle/programs/server/assets/app/config/settings.yml"
echo $comando
comando="sed -i 's/playback_protocol\: http/playback_protocol\: https/g' /usr/local/bigbluebutton/core/scripts/bigbluebutton.yml "
echo $comando
comando="sed -i 's/<!--<param name=\"enable-3pcc\" value=\"true\"\/>-->/<param name=\"enable-3pcc\" value=\"proxy\"\/>/g'  /opt/freeswitch/conf/sip_profiles/external-ipv6.xml"
echo $comando
comando="sed -i 's/Has sido eliminado de la conferencia/Has perdido conexión con la conferencia. Por favor intenta conectarte de nuevo/g' /usr/share/meteor/bundle/programs/server/assets/app/locales/es_MX.json"
echo $comando
comando="sed -i 's/Ha sido eliminado de la conferencia/Ha perdido conexión con la conferencia. Por favor intenta conectarte de nuevo/g' /usr/share/meteor/bundle/programs/server/assets/app/locales/es_ES.json"
echo $comando
comando="sed -i -e 's|defaultWelcomeMessage=.*|defaultWelcomeMessage=Bienvenido a <b>%%CONFNAME%%</b>!<br>|g' /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties"
echo $comando
comando="sed -i -e 's|defaultWelcomeMessageFooter=.*|defaultWelcomeMessageFooter=.|g' /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties"
echo $comando
comando="sed -i -e 's|userInactivityInspectTimerInMinutes=.*|userInactivityInspectTimerInMinutes=2|g' /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties"
echo $comando
comando="sed -i -e 's|userInactivityThresholdInMinutes=.*|userInactivityThresholdInMinutes=15|g' /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties"
echo $comando
comando="sed -i -e 's|userActivitySignResponseDelayInMinutes=.*|userActivitySignResponseDelayInMinutes=5|g' /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties"
echo $comando