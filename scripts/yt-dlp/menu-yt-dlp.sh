#!/usr/bin/env bash

# OPCIONES
opt1="Descargar un vídeo"
opt2="Descargar comentarios"
opt3="Descargar metadatos de un vídeo"
opt4="Descargar lista de reproducción"

# MENÚ
menu=$(zenity --list --title="YT-DLP" --radiolist \
--window-icon=/usr/share/OSINT-Icons/youtube.png --width=400 --height=300 \
--column="" --column="" \
FALSE "$opt1" \
FALSE "$opt2" \
FALSE "$opt3" \
FALSE "$opt4" )

case $menu in

	$opt1 )
		/opt/OSINT-Scripts/yt-dlp/descargar-video.sh
		;;
	$opt2 )
		/opt/OSINT-Scripts/yt-dlp/comentarios.sh
		;;
	$opt3 )
		/opt/OSINT-Scripts/yt-dlp/metadatos.sh
		;;
	$opt4 )
		/opt/OSINT-Scripts/yt-dlp/playlist.sh
		;;
esac
