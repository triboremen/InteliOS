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
{ ffmpeg -i "$menu" -vn -ac 2 -ar 44100 -ab 320k -f mp3 $HOME/Vídeos/$timestamp.mp3; \
echo "Audio guardado en $HOME/Vídeos"; } > $tempfile 2>&1 \
| tail -f $tempfile \
| yad --text-info --title="Extrayendo audio..." \
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