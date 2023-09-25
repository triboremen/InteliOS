#!/bin/bash
echo "# ACTUALIZANDO SISTEMA"
sudo apt update && sudo apt upgrade -y

echo "# ACTUALIZANDO INSTALOADER"
cd /virtualenvs/instaloader
source bin/activate
pip3 install instaloader
deactivate

echo "# ACTUALIZANDO USERTOOL"
echo "# HOLEHE"
cd /virtualenvs/holehe
source bin/activate
python3 -m pip install holehe -U
deactivate

echo "# SHERLOCK"
cd /virtualenvs/sherlock/sherlock
git pull https://github.com/sherlock-project/sherlock.git
source ../bin/activate
python3 -m pip install -r requirements.txt
deactivate

echo "# MAIGRET"
cd /virtualenvs/maigret
source bin/activate
pip3 install maigret -U
deactivate

echo "# SOCIALSCAN"
cd /virtualenvs/socialscan
source bin/activate
pip install socialscan -U
deactivate

echo "# ACTUALIZANDO RASTREA-DOMINIOS"
echo "# THEHARVESTER"
cd /virtualenvs/theHarvester/theHarvester
sudo git pull https://github.com/laramies/theHarvester.git
source bin/activate
python3 -m pip install -r requirements.txt
deactivate

echo "# ACTUALIZANDO YT-DLP"
cd /virtualenvs/yt-dlp
source bin/activate
pip install yt-dlp -U
deactivate

echo "# ACTUALIZANDO WHOOGLE"
cd /virtualenvs/whoogle/whoogle-search
sudo git pull https://github.com/benbusby/whoogle-search.git
source ../bin/activate
pip install -r requirements.txt
deactivate

echo "# ACTUALIZANDO JOPLIN Y DRAW.IO"
am -u

sudo apt autoremove -y
echo
echo ¡Actualizaciones completadas!
echo
read -p "Pulsa cualquier tecla para continuar"
