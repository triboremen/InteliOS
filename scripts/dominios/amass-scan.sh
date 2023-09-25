#!/usr/bin/env bash
#
########################## COMPRUEBA SI EXISTE EL DIRECTORIO ###########################
#
if [ ! -d $HOME/Documentos/Amass ]
then
	mkdir $HOME/Documentos/Amass
fi
#
##################################### MENU ###################################

menu=$(yad --title="Amass" --window-icon=/usr/share/OSINT-Icons/amass_logo.png --width=400 --height=200 \
--form \
--field="Dominio: " '' \
--field="Selecciona un escaneo: ":CB 'Pasivo (Rápido)\!Activo (Lento)' \
--field="Mostrar IPs (Sólo Escaneo ACTIVO)":CHK '' \
--field="Guardar en: ":DIR $HOME/Documentos/Amass )

##################################### VARIABLES ###########################
#
#DOMINIO
domain=$(echo $menu | gawk -F'|' '{ print $1 }')
#ESCANEO
scan=$(echo $menu | gawk -F'|' '{ if ($2 == "Pasivo (Rápido)") print "-passive"; else print "-active" }')
#IPs
ip=$(echo $menu | gawk -F'|' '{ if ($3 == "FALSE") print ""; else print "-ip" }')
#
#GUARDAR EN
save=$(echo $menu | gawk -F'|' '{ print "-dir",$4"/"$1 }')
#
############################ CREAR ARCHIVO TEMPORAL DONDE GUARDAR EL PROGRESO ################
#
tempfile=$(mktemp -t amass.XXXXXX)
#
############################################ MENSAJE DE ERROR #################################

if [[ $ip = "-ip" && $scan = "-passive" ]]
then
	yad --title=Amass --window-icon=/usr/share/OSINT-Icons/amass_logo.png \
	--text="<big><big>NO se pueden mostrar direcciones IP con un Escaneo PASIVO.</big></big>" \
	--button="OK"
	exit
fi

############################################ FUNCIÓN famass ###################################
#
famass() {
exec > $tempfile
date > /dev/null
echo
echo "######################################### ESCANEO SELECCIONADO ####################################"
echo
echo "  amass enum -d $domain $scan $ip $save"
echo
echo "########################################### ESCANEANDO #######################################"
echo "	  (Puede que tarde un rato y dé la sensación de que el programa se ha quedado colgado )"
echo
amass enum -d $domain $scan $ip $save
echo
echo "########################################## ESCANEO COMPLETADO ##################################"
echo
echo "Archivos guardados en"$save | sed 's/-dir//g'
}
#
###################################### EJECUCIÓN SOFTWARE ################################
#
famass \
| tail -f $tempfile \
| yad --text-info --title="Amass" --window-icon=/usr/share/OSINT-Icons/amass_logo.png \
--button="Cerrar" \
--width=680 --height=500 > $tempfile --tail
#
#
##################################### BORRAR ARCHIVO ###########################################
#
rm -f $tempfile
#
################################### ABRIR GRÁFICO? ################################################
#
location=$(echo $save | sed 's/-dir //g')

yad --title=Amass --window-icon=/usr/share/OSINT-Icons/amass_logo.png \
--text="¿Deseas abrir el gráfico?" \
--button="No":1 \
--button="Sí":0

case $? in						# INSPECCIONA EL CÓDIGO DE SALIDA

	1)						# SI CÓDIGO DE SALIDA=1 (NO), CIERRA DIÁLOGO DE YAD
	exit 0
	;;
	
	0)						# SI CÓDIGO SALIDA=0 (SÍ):
	amass viz -d3 $save				# CREA EL ARCHIVO HTML
	firefox $location/amass.html			# ABRE EL GRÁFICO EN FIREFOX
	exit 0						# CIERRA EL DIÁLOGO DE YAD
	;;

	esac
#