#!/usr/bin/env bash
#
# ACTIVAR ENTORNO VIRTUAL 
source /virtualenvs/yt-dlp/bin/activate

# COMPROBAR SI EXISTE CARPETA DESTINO
if [ ! -d $HOME/Vídeos/Comentarios ]
then
	mkdir $HOME/Vídeos/Comentarios
	cd $HOME/Vídeos/Comentarios
else
	cd $HOME/Vídeos/Comentarios
fi

# MENÚ
menu=$(yad --title="Descargar comentarios" --window-icon=/usr/share/OSINT-Icons/youtube.png \
--form \
--field="URL del vídeo: " "" \
--button="OK" \
--width=300 )

# VARIABLE
url=$(echo $menu | gawk -F'|' '{ print $1 }')

# CREAR ARCHIVO TEMPORAL
tempfile=$(mktemp -t yt-comments.XXXXXX)

# EJECUCIÓN PROGRAMA
{ yt-dlp --skip-download --get-comments --print-to-file "%(comments)j" \
"COMMENTS.%(title)s.json" "$url"; rm -f *.info.json; } > $tempfile 2>&1 \
| tail -f $tempfile \
| yad --text-info --title="Descargando comentarios..." --window-icon=/usr/share/OSINT-Icons/youtube.png \
--button="Cancelar":"pkill yt-dlp" \
--button="Salir" \
--button="OK":1 \
--width=700 --height=500 > $tempfile --tail

case $? in
	1)
	thunar $HOME/Vídeos/Comentarios
	exit 0
	;;
esac

# CERRAR PROGRAMA
rm -f $tempfile
deactivate
exit

