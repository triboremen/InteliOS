#!/usr/bin/env bash
#
cd /virtualenvs/instaloader
source bin/activate
#
######### DEFINIMOS OPCIONES DE DIÁLOGO COMO VARIABLES ############
opt1="Descargar perfil (sin registro)"
opt2="Descargar post"
#############################################################

######################### MENU ####################################################################
mainmenu=$(yad --title="Instaloader" --window-icon=/usr/share/OSINT-Icons/instaloader.png --form \
--field=:CB "$opt1"\!"$opt2" \
--width=300 --height=100 )
###########################################################################################
################################## BAMBALINAS ####################################################
#
if [ "$mainmenu" = "$opt1|" ]
then
	########## COMPRUEBA QUE EL DIRECTORIO DE LOS PERFILES EXISTE ###################
	
	if [ -d $HOME/Documentos/instaloader/ ]
	then
		cd $HOME/Documentos/instaloader/
	else
		mkdir $HOME/Documentos/instaloader/
		cd $HOME/Documentos/instaloader/
	fi

	##################################################################################
	#MENU
	menu=$(yad --title="Instaloader (SIN registro)" --window-icon=/usr/share/OSINT-Icons/instaloader.png --form \
	--field="Nombre de usuario: ":TXT )
	
	#VARIABLE QUE ALMACENA EL NOMBRE DE USUARIO
	username=$(echo $menu | gawk -F '|' '{ print $1 }')

	#CREA EL ARCHIVO TEMPORAL PARA MOSTRAR LOS PROGRESOS
	tempfile=$(mktemp -t instaloader.XXXXXX)

	#################### EJECUCIÓN PROGRAMA ########################
	instaloader $username > $tempfile \
	| tail -f $tempfile \
	| yad --text-info --title="Instaloader (SIN registro)" \
	--button="Cancelar":"kill $(ps aux | grep instaloader | gawk '{ print $2 }')" \
	--button="Cerrar" \
	--window-icon=/usr/share/OSINT-Icons/instaloader.png --width=500 --height=500 > $tempfile --tail
	
	#DESACTIVAR ENTORNO VIRTUAL
	deactivate
	
	#BORRA ARCHIVO TEMPORAL
	rm -f $tempfile

	#ABRE PERFIL QUE ACABAMOS DE DESCARGAR
	thunar ~/Documentos/instaloader/$username
#
elif [ "$mainmenu" = "$opt2|" ]
then
	########## COMPRUEBA QUE EL DIRECTORIO DE LOS POSTS EXISTE ###################
	
	if [ -d $HOME/Documentos/instaloader/posts ]
	then
		cd $HOME/Documentos/instaloader/posts
	else
		mkdir -p $HOME/Documentos/instaloader/posts
		cd $HOME/Documentos/instaloader/posts
	fi

	############################################################################
	#MENÚ
	menu=$(yad --title="Instaloader Posts" --form \
	--field="ID del post (Ej: BpkRCdPn8pr)":)

	#CREA EL ARCHIVO TEMPORAL PARA MOSTRAR LOS PROGRESOS
	tempfile=$(mktemp -t instaloader.XXXXXX)

	#VARIABLE QUE ALMACENA URL DEL POST
	post=$(echo $menu | gawk -F'|' '{ print $1 }')

	############## FUNCIÓN instafunc #####################

	instafunc() {
	exec > $tempfile
	date > /dev/null
	echo Descargando...
	instaloader -- -$post
	echo "Post guardado en ~/Documentos/instaloader/posts/-$post"
	}
	######################################################
	#################### EJECUCIÓN PROGRAMA ########################

	instafunc \
	| tail -f $tempfile \
	| yad --text-info --title="Instaloader Posts" \
	--window-icon=/usr/share/OSINT-Icons/instaloader.png --width=500 --height=300 > $tempfile --tail
	
	#DESACTIVAR ENTORNO VIRTUAL
	deactivate
	
	#BORRA ARCHIVO TEMPORAL
	rm -f $tempfile
	
	#ABRE EL POST QUE ACABAMOS DE DESCARGAR
	thunar ~/Documentos/instaloader/posts/"-$post"
fi
