#!/usr/bin/env bash

cd /virtualenvs/socialscan
source bin/activate

menu=$(yad --title=SocialScan --window-icon=/usr/share/OSINT-Icons/usertool.png --form \
--field="Nombre de usuario" "" \
--field="Guardar escaneo en:":DIR $HOME/Documentos)

#Extrae el nombre de usuario
username=$(echo $menu | gawk -F'|' '{ print $1 }')
#
#Extrae la ubicación. Por defecto: /home/usuario/Documentos
location=$(echo $menu | gawk -F'|' '{ print $2 }')

#CREAMOS LOG EN /temp
tempfile=$(mktemp -t socialscan.XXXXXX)

######################### FUNCIÓN socialfunction #################################################
# exec > $tempfile indica que el output de todos los comandos ejecutados a continuación irán a 
# parar a $tempfile
##SE HA ESCRITO date PORQUE, POR ALGUNA RAZÓN, DE LO CONTRARIO, EL PRIMER ECHO NO QUEDA REGISTRADO
##EN EL ARCHIVO Y, POR LO TANTO, NO SE MUESTRA EN EL DIÁLOGO
#
socialfunction() {
exec > $tempfile
date > /dev/null
echo "Escaneando $username. Por favor espere."
socialscan $username --json $location/"$username"_socialscan.json
echo "Escaneo finalizado."
echo "Resultados guardados en '$location'/'$username'_socialscan.json"
echo "Pulsa OK para abrir en firefox"
}
##################################################################################################

#EN CASO DE QUE NO HAYAMOS ESCRITO UN NOMBRE DE USUARIO, UNA VENTANA NOS ADVIERTE
#Y CIERRA EL PROGRAMA
if [ -z $username ]
then
	yad --title=SocialScan \
	--text="<big><big>Debes introducir un nombre de usuario</big></big>"
	exit
fi

socialfunction | tail -f $tempfile | yad --text-info --title=SocialScan \
--button="Salir" --button="OK":"firefox $location/'$username'_socialscan.json" \
--width=700 --height=200 \
> $tempfile --tail

rm -f $tempfile
deactivate
exit
