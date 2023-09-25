#!/usr/bin/env bash

############################### DEFINICIONES OPCIONES FAKEDATAGEN ########################

# -n 1 = mostrar 1 resultado
#-b = mostrar datos bancarios
#-e = extendido. Ciudad, móvil, SS.

######################### FUNCION FDG #####################################################
# Cada línea filtra con sed la orden de FakeDataGen borrando aquellas partes que no nos
#interesan y los guarda en el archivo especificado.

fdg() {
cd /virtualenvs/FakeDataGen
source bin/activate
cd FakeDataGen
python3 FakeDataGen.py -n 1| sed '/_/D; /-/d; /+/d; /^$/D' > $HOME/Documentos/$filename
python3 FakeDataGen.py -e -n 1| sed '/_/D; /-/d; /+/d; /^$/D' >> $HOME/Documentos/$filename
python3 FakeDataGen.py -b -n 1| sed '/_/D; /-/d; /+/d; /^$/D' >> $HOME/Documentos/$filename
deactivate
}

############################## VARIABLES ###################################################

prefix="${1:-identidad_}"			# Primera parte del nombre del archivo

number=1					# El primer número que debe empezar a buscar el script

ext=txt						# Extensión del archivo

newcount="${2:-1}"				# Cantidad de archivos que se van a crear por click. En este caso, 1

filename="$prefix$number.$ext"			# Nombre del archivo

############################ MAQUINARIA ###################################################

while [ -e "$HOME/Documentos/$filename" ]	# Mientras exista el archivo
do
	number=$((number + 1))			# Incrementa en uno
	filename="$prefix$number.$ext"		# Formato del archivo
done

while ((newcount--))				# Réstale un valor al contador hasta que llegue a 0
do
	touch $HOME/Documentos/"$filename"	# Crea el archivo
	fdg					# Ejecuta la función
	thunar $HOME/Documentos/		# Abre la ubicación del archivo
	mousepad $HOME/Documentos/"$filename"	# Abre el archivo
	number=$((number + 1))			# Si ya hay otro archivo, súmale 1
	filename="$prefix$number.$ext"		# Nombre del archivo
done
