#!/usr/bin/env bash
#
cd /virtualenvs/theHarvester/theHarvester
source /virtualenvs/theHarvester/bin/activate
#
########################## COMPRUEBA SI EL DIRECTORIO EXISTE ###########################
#
if [ ! -d $HOME/Documentos/theHarvester ]
then
	mkdir $HOME/Documentos/theHarvester
fi
#
##################################### MENU ###################################
#
menu=$(yad --title="TheHarvester" --window-icon=/usr/share/OSINT-Icons/theharvester.png --width=350 --height=100 \
--form \
--field="Dominio: " '' \
--field="Forzar DNS (DNS Bruteforce)":CHK '' \
--field="Guardar en: ":DIR $HOME/Documentos/theHarvester )
#
##################################### VARIABLES ###########################
#
#DOMINIO
domain=$(echo $menu | gawk -F'|' '{ print $1 }')
#
#FUERZA BRUTA
bruteforce=$(echo $menu | gawk -F'|' '{ if ($2 == "TRUE") print "-c"; else print "" }')
#
#GUARDADO
save=$(echo $menu | gawk -F'|' '{ print $3"/"$1 }')
#
#FUENTES
sources=anubis,baidu,bing,bingapi,brave,certspotter,crtsh,dnsdumpster,duckduckgo,hackertarget,otx,rapiddns,sitedossier,subdomaincenter,subdomainfinderc99,threatminer,urlscan,yahoo
#
#FECHA
timestamp=$(date +%d-%m-%Y:%H:%M)
#
######################################### COMPRUEBA SI EXISTE EL DIRECTORIO DE GUARDADO ################################################
########################################### EN CASO DE QUE EL USUARIO LO MODIFIQUE #####################################################
#
if [ ! -d $save ]
then
	mkdir $save
fi
#
##########################################################################################################################
############################################################ CREAR ARCHIVO TEMPORAL #######################################################
#
tempfile=$(mktemp -t theHarvester.XXXXXX)
#
######################################################## FUNCIÓN harvest ####################################################################
#
harvest() {
exec > $tempfile
date > /dev/null
echo "######################################### ESCANEO SELECCIONADO ############################################"
echo
echo "theHarvester "
echo "	      -d $domain"
echo "	      -b anubisbaidu bing bingapi brave certspotter crtsh dnsdumpster duckduckgo hackertarget"
echo "	         otx rapiddns sitedossier subdomaincenter subdomainfinderc99 threatminer urlscan yahoo"
echo "	      $bruteforce"
echo "	      -f $save/$timestamp-$domain"
echo
echo "############################################# ESCANEANDO ##################################################"
echo "	  (Esto puede llevar un rato y puede dar la sensación de que el programa se ha quedado colgado)"
echo
python3 theHarvester.py -d $domain -b $sources $bruteforce -f $save"/"$timestamp-$domain
echo
echo "########################################## ESCANEO COMPLETADO #############################################"
echo
echo "Archivos guardados en $save"
}
#
###################################################### EJECUCIÓN DEL SOFTWARE ##############################################################
#
harvest \
| tail -f $tempfile \
| yad --text-info --title="theHarvester" --window-icon=/usr/share/OSINT-Icons/theharvester.png \
--button="Cancelar":"kill $(ps aux | grep theHarvester | gawk '{ print $2 }')" \
--button="Cerrar" \
--width=760 --height=500 > $tempfile --tail
#
#
################################################### BORRAR ARCHIVO TEMPORAL ################################################################
#
rm -f $tempfile
#
####################################################### SALIR ##############################################################################
deactivate
exit
