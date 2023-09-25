#!/usr/bin/env bash
#
# ACTIVAR ENTORNO VIRTUAL
source /virtualenvs/yt-dlp/bin/activate

# COMPROBAR SI EXISTE CARPETA DESTINO
if [ ! -d $HOME/Vídeos/Playlists ]
then
	mkdir $HOME/Vídeos/Playlists
	cd $HOME/Vídeos/Playlists
else
	cd $HOME/Vídeos/Playlists
fi

# MENÚ
menu=$(yad --title="Descargar Playlist " --window-icon=/usr/share/OSINT-Icons/youtube.png \
--form \
--field="URL del vídeo: " "" \
--button="OK" )

# VARIABLES
url=$(echo $menu | gawk -F'|' '{ print $1 }')

timestamp=$(date +%d-%m-%Y:%H:%M)

# CREAR ARCHIVO TEMPORAL
tempfile=$(mktemp -t yt-comment-down.XXXXXX)

# FUNCIÓN
playfunc() {
exec > $tempfile
echo "Descargando lista. Dependiendo del tamaño esto puede tardar unos minutos."
echo "Por favor espere..."
yt-dlp --flat-playlist --dump-single-json --no-warnings "$url" \
| jq "{"date": .upload_date,"title": .title,"URL": .webpage_url, "entries"}" > $HOME/Vídeos/Playlists/playlist.$timestamp.json
echo "#######################################################################"
echo "Descarga finalizada"
}

# EJECUCIÓN SOFTWARE
playfunc \
| tail -f $tempfile \
| yad --text-info --title="Descargando playlist..." --window-icon=/usr/share/OSINT-Icons/youtube.png \
--button="Cancelar":"pkill yt-dlp" \
--button="Salir" \
--button="OK":1 \
--width=600 --height=200 > $HOME/Vídeos/Playlists/playlist.$timestamp.json --tail

case $? in
	1)
	thunar $HOME/Vídeos/Playlists
	exit 0
	;;
esac

# CERRAR PROGRAMA
rm -f $tempfile
deactivate
exit