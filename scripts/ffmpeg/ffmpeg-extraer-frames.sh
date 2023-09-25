#!/usr/bin/env bash
#
####################################### VARIABLES #########################
#
timestamp=$(date +%d-%m-%Y:%H:%M)
tempfile=$(mktemp -t ffmpeg.XXXXXX)
#
####################################### MENÚ ####################################
#
menu=$(yad --title="Selecciona un vídeo" --window-icon=/usr/share/OSINT-Icons/videos.png \
--text-align=center --file-selection  \
--width=600 --height=400 )
#
################################# EJECUCIÓN SOFTWARE ############################
#
{ mkdir $HOME/Vídeos/$timestamp-frames; ffmpeg -y -i "$menu" -an -r 10 $HOME/Vídeos/$timestamp-frames/img%03d.bmp; \
echo "Frames guardados en $HOME/Vídeos/$timestamp-frames"; } > $tempfile 2>&1 \
| tail -f $tempfile \
| yad --text-info --title="Extrayendo frames..." \
--window-icon=/usr/share/OSINT-Icons/videos.png \
--button="Cancelar":"kill $(ps aux | grep ffmpeg | gawk '{ print $2 }')" \
--button="OK":0 \
--width=700 --height=500 > $tempfile --tail

case $? in
	
	0)
	thunar $HOME/Vídeos/$timestamp-frames
	exit 0
	;;

	esac
#
################################## CERRAR PROGRAMA ###############################
#
rm -f $tempfile
exit