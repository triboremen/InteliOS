#!/usr/bin/env bash
#
# ACTIVAR ENTORNO VIRTUAL
source /virtualenvs/yt-dlp/bin/activate

# MENÚ
menu=$(yad --title="YT-DLP" --window-icon=/usr/share/OSINT-Icons/youtube.png \
--form \
--field="URL del vídeo: " "" \
--field="Calidad":CB "La mejor"\!"Máx. 1080p"\!"Máx. 720p" \
--button="OK" )

# VARIABLES
timestamp=$(date +%d-%m-%Y:%H:%M)

url=$(echo $menu | gawk -F'|' '{ print $1 }')

quality=$(echo $menu | gawk -F'|' '{ print $2 }')


if [ "$quality" == "La mejor" ]
then
	quality="-f bestvideo+bestaudio"

elif [ "$quality" == "Máx. 1080p" ]
then
	quality="-f bestvideo[height<=1080]+bestaudio"

elif [ "$quality" == "Máx. 720p" ]
then
	quality="-f bestvideo[height<=720]+bestaudio"
fi

# CREAR ARCHIVO TEMPORAL
tempfile=$(mktemp -t yt-dlp.XXXXXX)

# FUNCIÓN ytfunc
ytfunc() {
exec > $tempfile 2>&1
date > /dev/null
yt-dlp "$url" "$quality" -o ~/Vídeos/YouTube-DLP/"%(title)s.%(ext)s"
echo "########################################################################"
echo "Vídeo descargado con éxito."
}

# EJECUCIÓN
ytfunc \
| tail -f $tempfile \
| yad --text-info --title="Descargando vídeo..." --window-icon=/usr/share/OSINT-Icons/youtube.png \
--button="Cancelar":"pkill yt-dlp" \
--button="Salir" \
--button="OK":1 \
--width=700 --height=500 > $tempfile --tail

case $? in
	1)
	thunar $HOME/Vídeos/YouTube-DLP
	exit 0
	;;
esac
# CERRAR PROGRAMA
rm -f $tempfile
deactivate
exit