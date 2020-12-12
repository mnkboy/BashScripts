#!/bin/bash
#========================================================
#============== ARCHIVO DE FUNCIONES ==============
#========================================================
source "utils.sh"

#======================================================
#======================== MAIN ========================
#======================================================
#------------------------------------------------------------
#Creamos ruta de archivos prueba
RUTA_PRUEBAS_LOCAL=$(pwd)'/'$RUTA_PRUEBAS

#Creamos la carpeta de pruebas local
#Revisamos si existe la carpeta
if [ ! -d $RUTA_PRUEBAS_LOCAL ]; then
    #Si no existe la creamos
    mkdir -p $RUTA_PRUEBAS_LOCAL
fi

#Si no existe y  no la pudimos crear terminamos la ejecucion
if [ ! -d $RUTA_PRUEBAS_LOCAL ]; then
    echo "No existe la ruta: $RUTA_PRUEBAS_LOCAL "
    exit 1
fi

#------------------------------------------------------------
#Confirmamos nombre del servidor nuevo
imprimir_encabezado "Nombre del nuevo servidor"
confirmar "El nombre del servidor: \"$NOMBRE_SERVIDOR_NUEVO\" es correcto ?"
ejecutar "wget https://ubuntu.bigbluebutton.org/bbb-install.sh && chmod +x bbb-install.sh && ./bbb-install.sh -v xenial-22 -s $NOMBRE_SERVIDOR_NUEVO"

#------------------------------------------------------------
#Pedimos nombre del servidor de copia de archivos
imprimir_encabezado "Copiamos archivos"
confirmar "El nombre del servidor de copia es correcto: $SERVIDOR_COPIA ?"

#------------------------------------------------------------
#Eliminamos el instalador y copiamos ssl
imprimir_encabezado "Eliminamos el instalador y copiamos ssl"
ejecutar "rm bbb-install.sh && mkdir $RUTA_SSL/ssl && scp $USUARIO_COPIA@$SERVIDOR_COPIA:$RUTA_SSL/ssl/* $RUTA_SSL/ssl"

#------------------------------------------------------------
#Copiamos Ico y Pdf
imprimir_encabezado "Copiamos Ico y Pdf"
ejecutar "wget https://$SERVIDOR_COPIA/favicon.ico -O  /var/www/bigbluebutton-default/favicon.png"
ejecutar "wget https://$SERVIDOR_COPIA/default.pdf  -O /var/www/bigbluebutton-default/default.pdf"

#------------------------------------------------------------
#Edicion de archivos
imprimir_encabezado "Edicion de archivos"
ejecutar "sed -i '5i listen 443 ssl;' /etc/nginx/sites-available/bigbluebutton"
ejecutar "sed -i '6i listen [::]:443 ssl;' /etc/nginx/sites-available/bigbluebutton"
ejecutar "sed -i '7i ssl_certificate /etc/nginx/ssl/fullchain.pem;' /etc/nginx/sites-available/bigbluebutton"
ejecutar "sed -i '8i ssl_certificate_key /etc/nginx/ssl/privkey.pem;' /etc/nginx/sites-available/bigbluebutton"
ejecutar "sed -i '9i ssl_session_cache shared:SSL:10m;' /etc/nginx/sites-available/bigbluebutton"
ejecutar "sed -i '10i ssl_protocols TLSv1 TLSv1.1 TLSv1.2;' /etc/nginx/sites-available/bigbluebutton"
ejecutar "sed -i '11i ssl_ciphers \"ECDH+AESGCM:DH+AESGCM:ECDH+AES256:DH+AES256:ECDH+AES128:DH+AES:ECDH+3DES:DH+3DES:RSA+AESGCM:RSA+AES:RSA+3DES:!aNULL:!MD5:!DSS:!AES256\";' /etc/nginx/sites-available/bigbluebutton"
ejecutar "sed -i '12i ssl_prefer_server_ciphers on;' /etc/nginx/sites-available/bigbluebutton"
ejecutar "sed -i '13i ssl_dhparam /etc/nginx/ssl/dhp-4096.pem;' /etc/nginx/sites-available/bigbluebutton"

#------------------------------------------------------------
#Obtenemos IPv4 e IPv6
imprimir_encabezado "Obtenemos IPv4 e IPv6"
#IPv4
IPv4=`ip addr | grep "inet" | grep "/32" | sed 's/\/32.*//' | sed 's/\/32//' | sed 's/\inet\ //'`
#IPv6
IPv6=`ip addr | grep "inet6" | grep "/64" | sed 's/\/64.*//' | sed 's/\/64//' | sed 's/\inet6\ //'`


#------------------------------------------------------------
#Agregamos IPv4 e IPv6 al archivo
imprimir_encabezado "Agregamos IPv4 e IPv6 al archivo"
cat > $RUTA_IP_V4_V6'/'bigbluebutton_sip_addr_map.conf <<EOF
map \$remote_addr \$freeswitch_addr {
    "~:"    [$IPv6];
    default    $IPv4;
}
EOF

cat $RUTA_IP_V4_V6'/'bigbluebutton_sip_addr_map.conf

#------------------------------------------------------------
#Creamos archivo $freeswitch
imprimir_encabezado "Creamos archivo \$freeswitch"
cat > $RUTA_FREE_SWITCH'/'sip.nginx << EOF
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

cat $RUTA_FREE_SWITCH'/'sip.nginx

#--------------------------------------------------
#Modificaciones de archivos
imprimir_encabezado "Modificaciones de archivos"

ejecutar "sed -i 's/30m/150m/g' /etc/bigbluebutton/nginx/web.nginx "
ejecutar "sed -i 's/maxFileSizeUpload=30000000/maxFileSizeUpload=150000000/g'  /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties "
ejecutar "sed -i 's/worker_connections 768/worker_connections 6000/g' /etc/nginx/nginx.conf"
ejecutar "sed -i 's/uploadSizeMax: 50000000/uploadSizeMax: 150000000/g' /usr/share/meteor/bundle/programs/server/assets/app/config/settings.yml "
ejecutar "sed -i 's/bigbluebutton.web.serverURL=http/bigbluebutton.web.serverURL=https/g' /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties"
ejecutar "sed -i 's/jnlpUrl=http/jnlpUrl=https/g' /usr/share/red5/webapps/screenshare/WEB-INF/screenshare.properties"
ejecutar "sed -i 's/jnlpFile=http/jnlpFile=https/g' /usr/share/red5/webapps/screenshare/WEB-INF/screenshare.properties"
ejecutar "sed -e 's|http://|https://|g' -i /var/www/bigbluebutton/client/conf/config.xml"
ejecutar "sed -i 's/url: http\:\/\//url: https\:\/\//g' /usr/share/meteor/bundle/programs/server/assets/app/config/settings.yml"
ejecutar "sed -i 's/wsUrl: ws\:/wsUrl: wss\:/g' /usr/share/meteor/bundle/programs/server/assets/app/config/settings.yml"
ejecutar "sed -i 's/playback_protocol\: http/playback_protocol\: https/g' /usr/local/bigbluebutton/core/scripts/bigbluebutton.yml "
ejecutar "sed -i 's/<!--<param name=\"enable-3pcc\" value=\"true\"\/>-->/<param name=\"enable-3pcc\" value=\"proxy\"\/>/g'  /opt/freeswitch/conf/sip_profiles/external-ipv6.xml"
ejecutar "sed -i 's/Has sido eliminado de la conferencia/Has perdido conexión con la conferencia. Por favor intenta conectarte de nuevo/g' /usr/share/meteor/bundle/programs/server/assets/app/locales/es_MX.json"
ejecutar "sed -i 's/Ha sido eliminado de la conferencia/Ha perdido conexión con la conferencia. Por favor intenta conectarte de nuevo/g' /usr/share/meteor/bundle/programs/server/assets/app/locales/es_ES.json"
ejecutar "sed -i -e 's|defaultWelcomeMessage=.*|defaultWelcomeMessage=Bienvenido a <b>%%CONFNAME%%</b>!<br>|g' /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties"
ejecutar "sed -i -e 's|defaultWelcomeMessageFooter=.*|defaultWelcomeMessageFooter=.|g' /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties"
ejecutar "sed -i -e 's|userInactivityInspectTimerInMinutes=.*|userInactivityInspectTimerInMinutes=2|g' /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties"
ejecutar "sed -i -e 's|userInactivityThresholdInMinutes=.*|userInactivityThresholdInMinutes=15|g' /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties"
ejecutar "sed -i -e 's|userActivitySignResponseDelayInMinutes=.*|userActivitySignResponseDelayInMinutes=5|g' /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties"

#--------------------------------------------------
#Copiamos archivo
imprimir_encabezado "Copiamos archivo"
ejecutar "cp /usr/share/bbb-web/WEB-INF/classes/spring/turn-stun-servers.xml /usr/share/bbb-web/WEB-INF/classes/spring/turn-stun-servers.original"


#--------------------------------------------------
#Sturn
imprimir_encabezado "Sturn"
cat  > $RUTA_STURN'/'turn-stun-servers.xml <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:schemaLocation="http://www.springframework.org/schema/beans
        http://www.springframework.org/schema/beans/spring-beans-2.5.xsd">

    <bean id="stun0" class="org.bigbluebutton.web.services.turn.StunServer">
        <constructor-arg index="0" value="stun:$SERVIDOR_STURN"/>
    </bean>


    <bean id="turn0" class="org.bigbluebutton.web.services.turn.TurnServer">
        <constructor-arg index="0" value="7db29d66755c37a95a478f99cb019750"/>
        <constructor-arg index="1" value="turns:$SERVIDOR_STURN:443?transport=tcp"/>
        <constructor-arg index="2" value="86400"/>
    </bean>
    
    <bean id="turn1" class="org.bigbluebutton.web.services.turn.TurnServer">
        <constructor-arg index="0" value="7db29d66755c37a95a478f99cb019750"/>
        <constructor-arg index="1" value="turn:$SERVIDOR_STURN:443?transport=tcp"/>
        <constructor-arg index="2" value="86400"/>
    </bean>

    <bean id="stunTurnService"
            class="org.bigbluebutton.web.services.turn.StunTurnService">
        <property name="stunServers">
            <set>
                <ref bean="stun0"/>
            </set>
        </property>
        <property name="turnServers">
            <set>
                <ref bean="turn0"/>
                <ref bean="turn1"/>
            </set>
        </property>
    </bean>
</beans>
EOF

cat  > $RUTA_STURN'/'turn-stun-servers.xml
#--------------------------------------------------
#Edicion de archivos
imprimir_encabezado "Edicion de archivos"

ejecutar "yq w -i /usr/share/meteor/bundle/programs/server/assets/app/config/settings.yml public.kurento.cameraProfiles.[6].bitrate 30"
ejecutar "yq w -i /usr/share/meteor/bundle/programs/server/assets/app/config/settings.yml public.kurento.cameraProfiles.[6].default true "
ejecutar "yq w -i /usr/share/meteor/bundle/programs/server/assets/app/config/settings.yml public.kurento.cameraProfiles.[7].bitrate 80"
ejecutar "yq w -i /usr/share/meteor/bundle/programs/server/assets/app/config/settings.yml public.kurento.cameraProfiles.[7].default false"
ejecutar "yq w -i /usr/share/meteor/bundle/programs/server/assets/app/config/settings.yml public.kurento.cameraProfiles.[8].bitrate 130"
ejecutar "yq w -i /usr/share/meteor/bundle/programs/server/assets/app/config/settings.yml public.kurento.cameraProfiles.[8].default false"
ejecutar "yq w -i /usr/share/meteor/bundle/programs/server/assets/app/config/settings.yml public.kurento.cameraProfiles.[9].bitrate 180"
ejecutar "yq w -i /usr/share/meteor/bundle/programs/server/assets/app/config/settings.yml public.kurento.cameraProfiles.[9].default false"

#--------------------------------------------------
imprimir_encabezado "Cambio de propietario"
ejecutar "chown meteor:meteor /usr/share/meteor/bundle/programs/server/assets/app/config/settings.yml"

#Edicion de archivos
imprimir_encabezado "Edicion de archivos"
ejecutar "sed -i -e 's/LimitCORE=infinity/#LimitCORE=infinity/g' /lib/systemd/system/freeswitch.service"
ejecutar "sed -i -e 's/LimitNOFILE=100000/#LimitNOFILE=100000/g' /lib/systemd/system/freeswitch.service"
ejecutar "sed -i -e 's/LimitNPROC=60000/#LimitNPROC=60000/g' /lib/systemd/system/freeswitch.service"
ejecutar "sed -i -e 's/LimitSTACK=250000/#LimitSTACK=250000/g' /lib/systemd/system/freeswitch.service"
ejecutar "sed -i -e 's/LimitRTPRIO=infinity/#LimitRTPRIO=infinity/g' /lib/systemd/system/freeswitch.service"
ejecutar "sed -i -e 's/LimitRTTIME=7000000/#LimitRTTIME=7000000/g' /lib/systemd/system/freeswitch.service"
ejecutar "sed -i -e 's/IOSchedulingClass=realtime/#IOSchedulingClass=realtime/g' /lib/systemd/system/freeswitch.service"
ejecutar "sed -i -e 's/IOSchedulingPriority=2/#IOSchedulingPriority=2/g' /lib/systemd/system/freeswitch.service"
ejecutar "sed -i -e 's/CPUSchedulingPolicy=rr/#CPUSchedulingPolicy=rr/g' /lib/systemd/system/freeswitch.service"
ejecutar "sed -i -e 's/CPUSchedulingPriority=89/#CPUSchedulingPriority=89/g' /lib/systemd/system/freeswitch.service"
ejecutar "sed -i '32i LimitCORE=infinity'  /lib/systemd/system/freeswitch.service"
ejecutar "sed -i '33i LimitNOFILE=999999'  /lib/systemd/system/freeswitch.service"
ejecutar "sed -i '34i LimitNPROC=infinity'  /lib/systemd/system/freeswitch.service"
ejecutar "sed -i '35i LimitSTACK=250000'  /lib/systemd/system/freeswitch.service"
ejecutar "sed -i '36i LimitDATA=infinity'  /lib/systemd/system/freeswitch.service"
ejecutar "sed -i '37i LimitFSIZE=infinity'  /lib/systemd/system/freeswitch.service"
ejecutar "sed -i '38i LimitSIGPENDING=infinity'  /lib/systemd/system/freeswitch.service"
ejecutar "sed -i '39i LimitMSGQUEUE=infinity'  /lib/systemd/system/freeswitch.service"
ejecutar "sed -i '40i LimitAS=infinity'  /lib/systemd/system/freeswitch.service"
ejecutar "sed -i '41i LimitLOCKS=infinity'  /lib/systemd/system/freeswitch.service"
ejecutar "sed -i '42i LimitMEMLOCK=infinity'  /lib/systemd/system/freeswitch.service"
ejecutar "sed -i '43i LimitRTPRIO=infinity'  /lib/systemd/system/freeswitch.service"
ejecutar "sed -i '44i LimitRTTIME=7000000'  /lib/systemd/system/freeswitch.service"
ejecutar "sed -i '45i IOSchedulingClass=realtime'  /lib/systemd/system/freeswitch.service"
ejecutar "sed -i '46i IOSchedulingPriority=2'  /lib/systemd/system/freeswitch.service"
ejecutar "sed -i '47i CPUSchedulingPolicy=rr'  /lib/systemd/system/freeswitch.service"
ejecutar "sed -i '48i CPUSchedulingPriority=89'  /lib/systemd/system/freeswitch.service"
ejecutar "sed -i '49i \\n'  /lib/systemd/system/freeswitch.service"

#--------------------------------------------------
#Reinicio de servicios
imprimir_encabezado "Reinicio de servicios"
ejecutar "systemctl daemon-reload"
ejecutar "systemctl restart freeswitch.service redis.service kurento-media-server.service"
ejecutar "systemctl status freeswitch.service redis.service kurento-media-server.service"


#--------------------------------------------------
#Configuracion Kurento
imprimir_encabezado "Configuracion Kurento"
ejecutar "echo \"stunServerAddress=172.217.212.127\" >> /etc/kurento/modules/kurento/WebRtcEndpoint.conf.ini"
ejecutar "echo \"stunServerPort=19302\" >> /etc/kurento/modules/kurento/WebRtcEndpoint.conf.ini"

#--------------------------------------------------
#Correccion HTTPS
imprimir_encabezado "Correccion HTTPS"
ejecutar "sed -i 's,bbbWebAPI=\"http://,bbbWebAPI=\"https://,g' /usr/share/bbb-apps-akka/conf/application.conf"

#--------------------------------------------------
#Secret servidor
imprimir_encabezado "Secret servidor"
ejecutar "bbb-conf --setsecret $SECRET"
ejecutar "bbb-conf --restart"
ejecutar "bbb-conf --check"

#--------------------------------------------------
#Scalelite
imprimir_encabezado "Scalelite"

ejecutar "groupadd -g 2000 scalelite-spool"
ejecutar "usermod -a -G scalelite-spool bigbluebutton"
ejecutar "mkdir /home/bigbluebutton"
ejecutar "chown bigbluebutton:bigbluebutton /home/bigbluebutton"
ejecutar "usermod -d /home/bigbluebutton  bigbluebutton"
ejecutar "su - bigbluebutton -s /bin/bash"
ejecutar "mkdir -p ~/.ssh ; chmod 0700 ~/.ssh"

cat > $RUTA_SSH/scalelite << EOF
-----BEGIN OPENSSH PRIVATE KEY-----
b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAAAMwAAAAtzc2gtZW
QyNTUxOQAAACBTlkj7uBUhuEQJjI9XXF5f8xUkrHVXlvULZYXoY7EePwAAAKBomp+LaJqf
iwAAAAtzc2gtZWQyNTUxOQAAACBTlkj7uBUhuEQJjI9XXF5f8xUkrHVXlvULZYXoY7EePw
AAAECIr9gQdNPbsDrJ8bIuksyY8sQke4su4FVCWqulF5qnwlOWSPu4FSG4RAmMj1dcXl/z
FSSsdVeW9QtlhehjsR4/AAAAHWJpZ2JsdWVidXR0b25AaXAtMTcyLTMxLTQyLTk2
-----END OPENSSH PRIVATE KEY-----
EOF

ejecutar "chmod 400 $RUTA_SSH/scalelite"
ejecutar "cat $RUTA_SSH/scalelite"

cat > ~/$RUTA_SSH'/'config << EOF
Host records.school-manager.education
        User scalelite-spool
        IdentityFile ~/.ssh/scalelite

Host records1.school-manager.education
        User scalelite-spool
        IdentityFile ~/.ssh/scalelite

Host records2.school-manager.education
        User scalelite-spool
        IdentityFile ~/.ssh/scalelite

Host records3.school-manager.education
        User scalelite-spool
        IdentityFile ~/.ssh/scalelite

Host records4.school-manager.education
        User scalelite-spool
        IdentityFile ~/.ssh/scalelite

Host records5.school-manager.education
        User scalelite-spool
        IdentityFile ~/.ssh/scalelite
EOF

ejecutar "cat $RUTA_SSH/config"
ejecutar "chown bigbluebutton:bigbluebutton $RUTA_SSH/scalelite"
ejecutar "ssh $SERVIDOR_RECORDS"
ejecutar "exit"
ejecutar "exit"
ejecutar "git clone  https://github.com/blindsidenetworks/scalelite.git"
ejecutar "cd scalelite/bigbluebutton/"
ejecutar "cp  scalelite_post_publish.rb  /usr/local/bigbluebutton/core/scripts/post_publish"
ejecutar "cp scalelite.yml  /usr/local/bigbluebutton/core/scripts/"

cat > $RUTA_SCRIPTS_BBB'/'scalelite.yml  << EOF
# Directory for temporary storage of working files
work_dir: /var/bigbluebutton/recording/scalelite
#
# Directory to place recording files for scalelite to import
# If you are using a shared filesystem, this should be the local mountpoint on the BigBlueButton server.
spool_dir: records.school-manager.education:/var/scalelite-recordings/var/bigbluebutton/spool
        #spool_dir: records1.school-manager.education:/var/scalelite-recordings/var/bigbluebutton/spool
        #spool_dir: records2.school-manager.education:/var/scalelite-recordings/var/bigbluebutton/spool
        #spool_dir: records3.school-manager.education:/var/scalelite-recordings/var/bigbluebutton/spool
        #spool_dir: records4.school-manager.education:/var/scalelite-recordings/var/bigbluebutton/spool
        #spool_dir: records5.school-manager.education:/var/scalelite-recordings/var/bigbluebutton/spool
# If you are using rsync over ssh, this should be of the form [USER@]HOST:DEST
#spool_dir: scalelite-spool@scalelite-import.example.com:/var/bigbluebutton/spool
# If you are using an rsync daemon, this should be of the form [USER@]HOST::DEST or rsync://[USER@]HOST/DEST
#spool_dir: rsync://scalelite-spool@scalelite-import.example.com/spool
#
# Extra rsync command-line options
# You can use this to set up unusual configurations, like rsync daemon over ssh
extra_rsync_opts: []
EOF

#--------------------------------------------------
#Plugin MP4
imprimir_encabezado "Plugin MP4"
ejecutar "git clone https://github.com/createwebinar/bbb-download.git && cd bbb-download && chmod u+x install.sh "
ejecutar "sudo ./install.sh"
ejecutar "sudo bbb-record --rebuildall"
