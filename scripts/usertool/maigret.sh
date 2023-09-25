#!/bin/bash

cd /virtualenvs/maigret
source bin/activate

#DISEÑO DEL MENÚ
#ES OBLIGATORIO PONER '' AL FINAL DE CADA CAMPO SI QUEREMOS QUE :FL APUNTE
#AL DIRECTORIO QUE LE HEMOS DICHO.
menu=$(yad --title=Maigret --window-icon=/usr/share/OSINT-Icons/usertool.png --form \
--field="Nombre(s) de usuario" '' \
--field="Nº máximo de sitios":NUM 0\!0..500 \
--field="Escanear lista completa de sitios":CHK '' \
--field="":LBL '' \
--field="Etiquetas\n(Formato = photo,coding)" '' \
--align=center --field="\nforum gaming photo coding news blog music tech freelance\nsharing \
finance art shopping dating movies hobby hacking\nsport stock":LBL '' \
--field="":LBL '' \
--align=left --field=EXPORTAR:LBL '' \
--field="PDF":CHK '' \
--field="TXT":CHK '' \
--field="Guardar en":DIR $HOME/Documentos )

#DEFINIMOS LAS VARIABLES (FIELDS)
#VAR1
username=$(echo $menu | gawk -F'|' '{ print $1 }')
#VAR2
sites=$(echo $menu | gawk -F'|' '{ if ( $2 == 0 ) print "";else print "--top-sites",$2 }')
#VAR3
allsites=$(echo $menu | gawk -F'|' '{ if ($3 == "FALSE" ) print "";else print "-a" }')
#VAR4
tags=$(echo $menu | gawk -F'|' '{ if ( $5 == "" ) print ""; else print "--tags",$5 }')
#VAR5
pdf=$(echo $menu | gawk -F'|' '{ if ( $9 == "FALSE" ) print "";else print "-P -fo",$11 }')
#VAR6
txt=$(echo $menu | gawk -F'|' '{ if ( $10 == "FALSE" ) print "";else print "-T -fo",$11 }')

#ESTA VARIABLE LA HEMOS CREADO PARA PODER EJECUTAR EL SEGUNDO IF. PARTE $sites EN 2,
#QUEDÁNDONOS ASÍ CON EL VALOR DE $2, O SEA, EL NÚMERO DE SITIOS QUE ELEGIMOS
#
sitesnum="$( cut -d ' ' -f 2 <<< "$sites" )"
#
#EJEMPLO
#echo "\$sitesnum = $sitesnum"

#SI NO ESCRIBIMOS UN USUARIO, INTERRUMPE EL PROGRAMA
if [ -z $username ]
then
	yad --title=Maigret \
	--text="<big><big>Debes introducir un nombre de usuario.</big></big>"
	exit
fi
#
#SI LIMITAMOS LA CANTIDAD DE SITIOS A MIRAR Y AL MISMO TIEMPO PEDIMOS BUSCAR EN
#TODOS LOS SITIOS, INTERRUMPE EL PROGRAMA
if [[ "$sitesnum" > 0 && "$allsites" = "-a" ]]
then
	yad --title=Maigret \
	--text-align=center \
	--text="<big><big>\nNo puedes buscar en todos los sitios\n \
y al mismo tiempo limitar la búsqueda a cierto número de sitios</big></big>"
	exit
fi

#CREA UN LOG EN /temp
tempfile=$(mktemp -t maigret.XXXXXX)

############################ DEFINIMOS FUNCIÓN maigret ########################################## 
maigret() {
exec maigret $username $sites $allsites $tags $pdf $txt > $tempfile
echo "####################### ESCANEO COMPLETADO ###########################" >> $tempfile
echo "#### PARÁMETROS UTILIZADOS: maigret $username $sites $allsites $tags $pdf $txt ####" >> $tempfile
echo "######################################################################" >> $tempfile
}
################################################################################################

maigret | tail -f $tempfile | yad --text-info --title=Maigret --width=500 --height=500 \
> $tempfile --tail

rm -f $tempfile
rm -r reports
deactivate
exit
