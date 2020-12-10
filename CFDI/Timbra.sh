#!/bin/bash

#===========================================================
#======================== FUNCIONES ========================
#===========================================================

#Funcion para separar bloques de codigo
funcion_header () {
    echo;
    echo "=====================$1=====================";    
}


#Cargamos la variables de ambiente .env
source ".env"

#Establecemos rutas
CURRENT=$(pwd)
PEMS=$CURRENT'/3_PEMS'
CERTS=$CURRENT'/1_CERTS'
XSLTS=$CURRENT'/2_XSLT'
BINS=$CURRENT'/4_BINS'

#Creamos la carpeta de pems
funcion_header "VERIFICAMOS CARPETA PEMS"
if [ -d $PEMS ]; then
    echo "Existe la carpeta de pems en la ruta:"
    echo  $PEMS
else
    echo "No existe la carpeta de pems en la ruta $PEMS"
    echo "Se creara la carpeta $PEMS"
    mkdir -p $PEMS
fi

#Creamos la carpeta bins
funcion_header "VERIFICAMOS CARPETA BINS"
if [ -d $BINS ]; then
    echo "Existe la carpeta de bins en la ruta:"
    echo  $BINS
else
    echo "No existe la carpeta de bin en la ruta $BINS"
    echo "Se creara la carpeta $BINS"
    mkdir -p $BINS
fi

#Creamos el cer pem
funcion_header "CREAMOS CER PEM"
openssl x509 -inform DER -outform PEM -in $CERTS'/'$ARCHIVO_CER -pubkey > $PEMS'/'$ARCHIVO_CER_PEM

#Creamos el key pem
funcion_header "CREAMOS KEY PEM"
openssl pkcs8 -inform DER -in $CERTS'/'$ARCHIVO_KEY -out $PEMS'/'$ARCHIVO_KEY_PEM -passin pass:$PASS_KEY

#Sacamos el numero del certificado
funcion_header "SACAMOS NUMERO DEL CERTIFICADO"
NO_CER=`openssl x509 -in $PEMS'/'$ARCHIVO_CER_PEM -serial -noout | awk -vFS= '{for (i = 1; i <= NF; i+=2) {printf $i""} printf "\n"}'|sed 's/sra=//'`
echo $NO_CER

#Colocamos el numero de certificado en la factura
funcion_header "COLOCAMOS EL CERTIFICADO EN EL XML"
xmlstarlet ed -u '/cfdi:Comprobante/@NoCertificado' -v $NO_CER <$XML >$XML_FIRMADO

#A partir de aca todo es con el xml nuevo
funcion_header "A PARTIR DE AHORA SE USA EL XML NUEVO CON EL NO_CERTIFICADO"

#Generamos la cadena original
funcion_header "CADENA ORIGINAL"
CADENA_ORIGINAL=`xsltproc $XSLTS'/'$XSLT_CADENA_ORIGINAL $XML_FIRMADO`
echo $CADENA_ORIGINAL

# funcion_header "DGST + SHA256 A LA CADENA ORIGINAL"
funcion_header "DGST SHA256 -> CADENA ORIGINAL = HASH"
CADENA_ORIGINAL=`xsltproc $XSLTS'/'$XSLT_CADENA_ORIGINAL $XML_FIRMADO | openssl dgst -sha256 `
echo $CADENA_ORIGINAL

#Aplicamos el sello al hash de la cadena original
funcion_header "FIRMA -> HASH = CADENA FIRMADA"
CADENA_ORIGINAL=`xsltproc $XSLTS'/'$XSLT_CADENA_ORIGINAL $XML_FIRMADO | openssl dgst -sha256 -sign $PEMS'/'$ARCHIVO_KEY_PEM`
echo $CADENA_ORIGINAL

#Encriptamos a base 64 la cadena firmada
funcion_header "FIRMA_B64"
CADENA_ORIGINAL=`xsltproc $XSLTS'/'$XSLT_CADENA_ORIGINAL $XML_FIRMADO | openssl dgst -sha256 -sign $PEMS'/'$ARCHIVO_KEY_PEM | openssl enc -base64 -A`
echo $CADENA_ORIGINAL

#Colocamos el la cadena firmada base 64 en la factura
funcion_header "FIRMA_B64 EN FACTURA"
xmlstarlet ed -u '/cfdi:Comprobante/@NoCertificado' -v $NO_CER -u '/cfdi:Comprobante/@Sello' -v $CADENA_ORIGINAL <$XML >$XML_FIRMADO

#Comenzamos el proceso de verificacion
funcion_header "DESENCRIPTAMOS LA FIRMA_B64 A UN BYTE ARRAY (BIN)"
xsltproc $XSLTS'/'$XSLT_SELLO $XML_FIRMADO | openssl enc -base64 -d -A -out $BINS'/'$SELLO_BIN
cat $BINS'/'$SELLO_BIN

#Verificamos el sello
funcion_header "VERIFICAMOS EL SELLO"
xsltproc $XSLTS'/'$XSLT_CADENA_ORIGINAL $XML_FIRMADO   | openssl dgst -sha256 -verify $PEMS'/'$ARCHIVO_CER_PEM -signature $BINS'/'$SELLO_BIN