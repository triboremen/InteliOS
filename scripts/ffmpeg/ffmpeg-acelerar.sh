#!/usr/bin/env bash
#
####################################### MENÚ ####################################
#
menu=$(yad --title="Acelerar vídeo" --window-icon=/usr/share/OSINT-Icons/videos.png \
--form --width=300 --height=200 \
--field="Selecciona un vídeo: ":SFL '' \
--field="Aceleración":CB 'Baja\!Elevada' )
#
##################################### VARIABLES ################################
#
#RUTA ARCHIVO
file=$(echo $menu | gawk -F'|' '{ print $1 }')
#
#NOMBRE ACELERACIÓN
acel=$(echo $menu | gawk -F'|' '{ print $2 }')
#
#TIPO ACELERACIÓN
type=$(echo $menu | gawk -F'|' '{ if ( $2 == "Baja" ) print "0.003"; else print "0.005" }')
#
#MARCA DE TIEMPO
timestamp=$(date +%d-%m-%Y:%H:%M)
#
#CREAR ARCHIVO TEMPORAL
tempfile=$(mktemp -t ffmpeg.XXXXXX)
#
################################# EJECUCIÓN SOFTWARE ###########################
#
{ ffmpeg -i "$file" -strict -2 -vf "select=gt(scene\,$type),setpts=N/(25*TB)" \
$HOME/Vídeos/video-$acel-$timestamp.mp4; \
echo "Archivo guardado en $HOME/Vídeos"; } > $tempfile 2>&1 \
| tail -f $tempfile \
| yad --text-info --title="Acelerando vídeo..." \
--window-icon=/usr/share/OSINT-Icons/videos.png \
--button="Cancelar":"kill $(ps aux | grep ffmpeg | gawk '{ print $2 }')" \
--button="OK":0 \
--width=700 --height=500 > $tempfile --tail

case $? in
	
	0)
	thunar $HOME/Vídeos
	exit 0
	;;

	esac
#
################################## CERRAR PROGRAMA ###############################
#
rm -f $tempfile
exit