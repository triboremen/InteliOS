#!/usr/bin/env bash

opt1="Convertir a MP4"
opt2="Extraer frames"
opt3="Acelerar vídeo"
opt4="Extraer audio"
opt5="Rotar vídeo"

menu=$(zenity --list --title="FFMPEG" --radiolist \
--window-icon=/usr/share/OSINT-Icons/videos.png --width=300 --height=300 \
--column="" --column="" \
FALSE "$opt1" \
FALSE "$opt2" \
FALSE "$opt3" \
FALSE "$opt4" \
FALSE "$opt5" )

case $menu in

	$opt1)
	/opt/OSINT-Scripts/ffmpeg/ffmpeg-mp4-converter.sh
	;;
	$opt2)
	/opt/OSINT-Scripts/ffmpeg/ffmpeg-extraer-frames.sh
	;;
	$opt3)
	/opt/OSINT-Scripts/ffmpeg/ffmpeg-acelerar.sh
	;;
	$opt4)
	/opt/OSINT-Scripts/ffmpeg/ffmpeg-audio.sh
	;;
	$opt5)
	/opt/OSINT-Scripts/ffmpeg/ffmpeg-rotar.sh
	;;
esac