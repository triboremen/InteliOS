#!/usr/bin/env bash
#
##################################### VARIABLES ################################
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
################################# EJECUCIÓN SOFTWARE ###########################
#
{ ffmpeg -i "$menu" -vcodec mpeg4 -strict -2 $HOME/Vídeos/$timestamp.mp4; \
echo "Archivo guardado en $HOME/Vídeos"; } > $tempfile 2>&1 \
| tail -f $tempfile \
| yad --text-info --title="Convirtiendo vídeo..." \
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