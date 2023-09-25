#!/usr/bin/env bash
source /virtualenvs/sherlock/bin/activate
cd /virtualenvs/sherlock/sherlock/sherlock

menu=$(yad --title=Sherlock --window-icon=/usr/share/OSINT-Icons/usertool.png --form \
--field="Nombre(s) de usuario:TXT" \
--field="Guardar como txt:CHK")

#Extrae nombre de usuario
username=$(echo $menu | gawk -F'|' '{ print $1 }')
#
#Comprueba si queremos guardar en un archivo mediante TRUE/FALSE
savefile=$(echo $menu | gawk -F'|' '{ print $2 }')

#CREAMOS LOG EN /temp
tempfile=$(mktemp -t sherlock.XXXXXX)

######################### FUNCIÓN sherlockfunc #################################################
# exec > $tempfile indica que el output de todos los comandos ejecutados a continuación irán a 
# parar a $tempfile
##SE HA ESCRITO date PORQUE, POR ALGUNA RAZÓN, DE LO CONTRARIO, EL PRIMER ECHO NO QUEDA REGISTRADO
##EN EL ARCHIVO Y, POR LO TANTO, NO SE MUESTRA EN EL DIÁLOGO
#
sherlockfunc() {
exec > $tempfile
date > /dev/null
python3 sherlock.py $username -o $HOME/Documentos/"$username"_sherlock.txt
echo
echo "Resultados guardados en $HOME/Documentos/'$username'_sherlock.txt"
}
##################################################################################################

#EN CASO DE QUE NO HAYAMOS ESCRITO UN NOMBRE DE USUARIO, UNA VENTANA NOS ADVIERTE
#Y CIERRA EL PROGRAMA
if [ -z $username ]
then
	yad --title=Sherlock \
	--text="<big><big>Debes introducir un nombre de usuario</big></big>"
	exit
fi


if [ $savefile == TRUE ]
then
	sherlockfunc | tail -f $tempfile \
	| yad --text-info --title=Sherlock --window-icon=/usr/share/OSINT-Icons/usertool.png \
	--width=500 --height=500 \
	> $tempfile --tail
	rm -f $tempfile
	deactivate
	exit
else
	python3 sherlock.py $username > $tempfile \
	| tail -f $tempfile \
	| yad --text-info --title=Sherlock --window-icon=/usr/share/OSINT-Icons/usertool.png\
	--width=500 --height=500 \
	> $tempfile --tail
	rm -f $tempfile
	deactivate
	exit
fi
