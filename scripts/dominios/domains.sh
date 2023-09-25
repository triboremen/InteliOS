#!/usr/bin/env bash

opt1="Amass"
opt2="theHarvester"

menu=$(zenity --window-icon=/usr/share/OSINT-Icons/domains.png \
--list --radiolist --width=400 --height=250 \
--title="Rastrea-Dominios" --text="¿Qué deseas hacer?" \
--column="" --column="" \
false "$opt1" \
false "$opt2" )

echo $menu

case $menu in

$opt1 )
	/opt/OSINT-Scripts/dominios/amass.sh
	;;
$opt2 )
	/opt/OSINT-Scripts/dominios/theHarvester.sh
	;;
esac