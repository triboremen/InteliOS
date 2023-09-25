#!/usr/bin/env bash

##################################### VARIABLES ##################################################

opt1="Realizar escaneo"
opt2="Abrir gráfico"
opt3="Abrir txt"

timestamp=$(date +%d-%m-%Y:%H:%M)

###################################### ZENITY #################################################################

startmenu=$(zenity --window-icon=/usr/share/OSINT-Icons/amass_logo.png \
--list --radiolist --width=400 --height=250 \
--title="Amass" --text="¿Qué deseas hacer?" \
--column="" --column="" \
false "$opt1" \
false "$opt2" \
false "$opt3" )

case $startmenu in

$opt1 )
	/opt/OSINT-Scripts/dominios/amass-scan.sh
	;;

$opt2 )
	graph=$(zenity --title="Amass" --window-icon=/usr/share/OSINT-Icons/amass_logo.png \
	--file-selection --directory )
	#LA OPCIÓN --directory NOS PERMITE SELECIONAR SÓLO LOS DIRECTORIOS
	amass viz -d3 -dir $graph
	firefox $graph/amass.html
	;;
$opt3 )
	txt=$(zenity --title="Amass" --window-icon=/usr/share/OSINT-Icons/amass_logo.png \
	--file-selection )
	mousepad $txt
	;;
	
esac