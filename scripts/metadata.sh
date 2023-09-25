#!/usr/bin/env bash
#
######################################## VARIABLES ###################################
#
opt1="Extraer metadatos de un ARCHIVO"
opt2="Extraer metadatos de una CARPETA"
opt3="Eliminar metadatos"

tempfile=$(mktemp -t exiftool.XXXXXX)
#
########################################### MENÚ #######################################
#
menu=$(zenity --list --title "MetaTool" --radiolist \
--window-icon=/usr/share/OSINT-Icons/metadata.png \
--height=400 --width=300 \
--column "" --column "" \
FALSE "$opt1" \
FALSE "$opt2" \
FALSE "$opt3" )
#
#################################### EJECUCIÓN SOFTWARE #################################
#
case $menu in
			#### EXTRAER METADATOS DE UN ARCHIVO ####
$opt1 )

	exiftool_file=$(zenity --file-selection --title "Extracción ARCHIVO")

	exiftool $exiftool_file > $tempfile \
	| tail -f $tempfile \
	| yad --text-info --title="Extracción ARCHIVO" --width=600 --height=500 \
	--window-icon=/usr/share/OSINT-Icons/metadata.png \
	> $tempfile --tail
	rm -f $tempfile
	;;

			#### EXTRAER METADATOS DE UNA CARPETA ####

$opt2 )

	exiftool_folder=$(zenity --file-selection --directory --title "Extracción CARPETA")

	exiftool $exiftool_folder/* > $tempfile \
	| tail -f $tempfile \
	| yad --text-info --title="Extracción CARPETA" --width=600 --height=500 \
	--window-icon=/usr/share/OSINT-Icons/metadata.png \
	> $tempfile --tail
	rm -f $tempfile
	;;

			      #### ELIMINAR METADATOS ####

$opt3 )

	data_file=$(zenity --file-selection --title "Eliminar Metadatos")

	mat2 "$data_file" > $tempfile

	case $? in
	
		255)				# SI DETECTA UN ERROR (CÓD. 255), LO MUESTRA EN PANTALLA.
		cat $tempfile \
		| yad --text-info --title="Eliminar Metadatos" --width=600 --height=100 \
		--window-icon=/usr/share/OSINT-Icons/metadata.png \
		--button="OK" 
		rm -f $tempfile
		;;

		0)				# TODO HA SALIDO BIEN. ABRE LA UBICACIÓN DEL ARCHIVO LIMPIO.
		thunar "$data_file"
		;;
		esac
;;
esac
