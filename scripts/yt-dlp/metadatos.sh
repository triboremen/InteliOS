#!/usr/bin/env bash
#
# ACTIVAR ENTORNO VIRTUAL
source /virtualenvs/yt-dlp/bin/activate

# MENÚ
menu=$(yad --title="Descargar Metadatos" --window-icon=/usr/share/OSINT-Icons/youtube.png \
--form \
--field="URL del vídeo: " "" \
--button="OK" \
--width=300 )

# VARIABLES
url=$(echo $menu | gawk -F'|' '{ print $1 }')

# CREAR ARCHIVO TEMPORAL
tempfile=$(mktemp -t yt-comment-down.XXXXXX)

# EJECUCIÓN CÓDIGO
yt-dlp "$url" --skip-download --write-info-json -o ~/Vídeos/Metadatos/"%(title)s.$timestamp.%(ext)s" > $tempfile 2>&1 \
| tail -f $tempfile \
| yad --text-info --title="Descargando metadatos..." --window-icon=/usr/share/OSINT-Icons/youtube.png \
--button="Cancelar":"pkill yt-dlp" \
--button="Salir" \
--button="OK":1 \
--width=700 --height=500 > $tempfile --tail

case $? in
	1)
	thunar $HOME/Vídeos/Metadatos
	exit 0
	;;
esac

# CERRAR PROGRAMA
rm -f $tempfile
deactivate
exit