#!/usr/bin/env bash

cd /virtualenvs/holehe
source bin/activate

menu=$(yad --title=Holehe --window-icon=/usr/share/OSINT-Icons/usertool.png --form \
--field="Introduce email" \
--field="Mostrar cuentas donde esté registrado el correo":CHK \
--field="Guardar en un archivo":CHK)

email=$(echo $menu | gawk -F'|' '{ print $1 }')
used=$(echo $menu | gawk -F'|' '{ if ( $2 == "FALSE" ) print ""; else print "--only-used" }')
file=$(echo $menu | gawk -F'|' '{ print $3 }')

#Comprueba si se ha introducido un email. Si no ha sido así,
#muestra un aviso e interrumpe el programa.
#Los "big" indican el tamaño de la letra

if [ -z $email ]
then
	yad --title=Holehe \
	--text="<big><big>Debes introducir un email.</big></big>"
	exit
fi

if [ $file == TRUE ]
then
	holehe $email $used > $HOME/Documentos/"$email"-holehe.txt 2>&1 \
	| tail -f $HOME/Documentos/"$email"-holehe.txt \
	| yad --text-info --title=Holehe --window-icon=/usr/share/OSINT-Icons/usertool.png \
	--width=500 --height=500

	thunar $HOME/Documentos

else
	tempfile=$(mktemp -t holehe.XXXXXX)

	holehe $email $used > $tempfile 2>&1 \
	| tail -f $tempfile \
	| yad --text-info --title=Holehe --window-icon=/usr/share/OSINT-Icons/usertool.png \
	--width=500 --height=500 \
	> $tempfile --tail

	rm -f $tempfile
fi

deactivate
exit
