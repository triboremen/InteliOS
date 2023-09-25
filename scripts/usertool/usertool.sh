#!/usr/bin/env bash
menu=$(yad --title=Usertool --window-icon=/usr/share/OSINT-Icons/usertool.png --form \
--field="Elige una herramienta: ":CB Maigret\!Sherlock\!"Holehe (Email)"\!SocialScan )

echo $menu

if [ $menu = "Maigret|" ]
then
	/opt/OSINT-Scripts/usertool/maigret.sh
	exit
elif [ $menu = "Sherlock|" ]
then
	/opt/OSINT-Scripts/usertool/sherlock.sh
	exit
elif [ "$menu" = "Holehe (Email)|" ]
then
	/opt/OSINT-Scripts/usertool/holehe.sh
	exit
elif [ $menu = "SocialScan|" ]
then
	/opt/OSINT-Scripts/usertool/socialscan.sh
	exit
fi