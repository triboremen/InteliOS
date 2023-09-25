#REPOSITORIOS IMPORTANTES PARA QUE PUEDA DESCARGAR
#PROGRAMAS VIA APT

echo "# AÑADIENDO REPOSITORIOS UBUNTU"
add-apt-repository --yes main
add-apt-repository --yes restricted
add-apt-repository --yes universe
add-apt-repository --yes multiverse
#
echo "# INSTALANDO PAQUETES APT"
apt install -y git net-tools keepassxc vlc ripgrep filezilla p7zip-rar yad python3.10-venv \
python3-dev jq gawk gcc binutils coreutils curl sed tar unzip wget zsync
#
echo "# BORRANDO SNAP..."
apt purge -y snapd
#
echo "# CREANDO CARPETAS..."
mkdir /opt/OSINT-Scripts
mkdir /usr/share/OSINT-Icons
#mkdir /usr/share/joplin
mkdir -p /usr/local/share/applications
mkdir -p /etc/skel/.config/xfce4/xfconf/xfce-perchannel-xml
mkdir -p /etc/skel/.mozilla/firefox
mkdir /etc/skel/Escritorio
#
echo "# INSTALANDO FIREFOX"
wget --content-disposition -v "https://download.mozilla.org/?product=firefox-latest-ssl&os=linux64&lang=es-ES"
tar -xjf firefox-*.tar.bz2
mv firefox /opt
ln -s /opt/firefox/firefox /usr/local/bin/firefox
rm firefox-*.tar.bz2

echo "# CONFIGURANDO FIREFOX"
mv ~/InteliOS*/Firefox/* /etc/skel/.mozilla/firefox
#
# PYTHON
echo "# CREANDO ENTORNO VIRTUAL PARA PYTHON"
mkdir /virtualenvs
chmod 777 /virtualenvs
#
# USERTOOL
echo "# INSTALANDO PROGRAMAS PARA USERTOOL:"

echo "# SHERLOCK"
cd /virtualenvs
python3 -m venv sherlock --upgrade-deps
cd sherlock
source bin/activate
git clone https://github.com/sherlock-project/sherlock
cd sherlock
python3 -m pip install -r requirements.txt
deactivate

echo "# MAIGRET"
cd /virtualenvs
python3 -m venv maigret --upgrade-deps
cd maigret
source bin/activate
pip3 install maigret
deactivate

echo "# SOCIALSCAN"
cd /virtualenvs
python3 -m venv socialscan --upgrade-deps
cd socialscan
source bin/activate
pip install socialscan
deactivate

echo "# HOLEHE"
cd /virtualenvs
python3 -m venv holehe --upgrade-deps
cd holehe
source bin/activate
pip3 install holehe
deactivate	
#
echo "# INSTALANDO HERRAMIENTAS DE VÍDEO"
echo "# YT-DLP"
cd /virtualenvs
python3 -m venv yt-dlp --upgrade-deps
cd yt-dlp
source bin/activate
pip install yt-dlp
deactivate
	
echo "# FFMPEG"
apt install -y ffmpeg

echo "# EZYTDL"

cd /opt

apt-get install --no-install-recommends -y libvips42

VERSION=$(curl -I https://github.com/sylviiu/ezytdl/releases/latest \
| awk -F '/' '/^location/ {print  substr($NF, 1, length($NF)-1)}')

wget "https://github.com/sylviiu/ezytdl/releases/download/$VERSION/ezytdl-linux.AppImage"

chmod +x ./ezytdl-linux.AppImage
#	
echo "# INSTALANDO INSTALOADER"
cd /virtualenvs
python3 -m venv instaloader --upgrade-deps
cd instaloader
source bin/activate
pip3 install instaloader
deactivate
#		
echo "# INSTALANDO HERRAMIENTAS PARA DOMINIOS"
echo "# AMASS"
cd /usr/bin
wget --content-disposition https://github.com/OWASP/Amass/releases/download/v3.21.2/amass_linux_amd64.zip
unzip amass_linux_amd64.zip
rm amass_linux_amd64.zip
mv amass_linux_amd64/amass . && rm -R amass_linux_amd64/

echo "# THE HARVESTER"
cd /virtualenvs
python3 -m venv theHarvester --upgrade-deps
cd theHarvester
git clone https://github.com/laramies/theHarvester
source bin/activate
cd theHarvester
pip install -r requirements/base.txt
deactivate
#
echo "# INSTALANDO FAKEDATAGEN"
cd /virtualenvs
python3 -m venv FakeDataGen --upgrade-deps
cd FakeDataGen
source bin/activate
git clone https://github.com/JoelGMSec/FakeDataGen
cd FakeDataGen
pip install -r requirements.txt
deactivate
#	
echo "# INSTALANDO TOR BROWSER"
# SCRIPT OBTENIDO DE: https://www.reddit.com/r/TOR/comments/v4gewg/i_have_created_a_bash_script_that_automatically/
cd /etc/skel
version_url="https://dist.torproject.org/torbrowser/?C=M;O=D"
version="$(curl -s "$version_url" | grep -m 1 -Po "(?<=>)\d+.\d+(.\d+)?(?=/)")"
wget https://www.torproject.org/dist/torbrowser/${version}/tor-browser-linux-x86_64-${version}.tar.xz
tar -xf tor-browser-linux-x86_64-${version}.tar.xz
rm -f tor-browser-linux-x86_64-${version}.tar.xz
#
echo "# INSTALANDO HERRAMIENTAS PARA METADATOS"
echo "# LIBIMAGE-EXIFTOOL-PERL" 
apt install -y libimage-exiftool-perl

echo "# MAT2"
apt install -y mat2

echo "# MEDIAINFO"
apt install -y mediainfo-gui

echo "# INSTALANDO KAZAM"
apt install -y kazam
#
echo "# INSTALANDO WHOOGLE"
cd /virtualenvs
python3 -m venv whoogle --upgrade-deps
cd whoogle
git clone https://github.com/benbusby/whoogle-search.git
source bin/activate
cd whoogle-search
pip install -r requirements.txt
deactivate

mv ~/InteliOS*/whoogle/whoogle.service /lib/systemd/system/
systemctl enable whoogle
#
echo "# INSTALANDO AM (GESTOR DE PAQUETES APPIMAGES)"
wget https://raw.githubusercontent.com/ivan-hc/AM-application-manager/main/INSTALL && chmod a+x ./INSTALL && sudo ./INSTALL 

echo "# INSTALANDO HERRAMIENTAS DE DOCUMENTACIÓN"
echo "# JOPLIN (NOTAS)"
am -i joplin

echo "# DRAWIO"
am -i draw.io

echo "# GNUMERIC"
apt install -y gnumeric
#
echo "# INSTALANDO FACEBOOK_CHECKER"
cd ~/InteliOS*
mv FacebookChecker-linux-amd64 /usr/bin
#
echo "# INSTALANDO GET_USER_AGENT"
wget http://security.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.0g-2ubuntu4_amd64.deb
dpkg -i libssl1.1_1.1.0g-2ubuntu4_amd64.deb
rm -f libssl1.1_1.1.0g-2ubuntu4_amd64.deb

mv get_user_agent /usr/bin
#
echo "# CONFIGURANDO APARIENCIA"
cd ~/InteliOS*/xfce/
mv settings/* /etc/skel/.config/xfce4/xfconf/xfce-perchannel-xml

mv etc-settings/* /etc/xdg/xfce4/xfconf/xfce-perchannel-xml
#
cd ~/InteliOS*/
echo "# MOVIENDO SCRIPTS"
mv scripts/* /opt/OSINT-Scripts

echo "# ACTUALIZANDO MENÚ INICIO"
cd ~/InteliOS*/xfce
mv menu/*.directory /usr/share/desktop-directories
mv menu/xfce-applications.menu /etc/xdg/menus
mv "HERRAMIENTAS TELEGRAM" /etc/skel/Escritorio

cd ~/InteliOS*/
mv icons/inicio-menu.png /usr/share/pixmaps

echo "# ICONOS"
mv icons/* /usr/share/OSINT-Icons

echo "# FIREFOX"
mv shortcuts/firefox.desktop /usr/local/share/applications

echo "# SHORTCUTS"
mv shortcuts/* /usr/share/applications

echo "# WALLPAPER"
mv wallpaper/cyberwallpaper.jpg /usr/share/backgrounds/

echo "# INICIO S.O."
mv /usr/share/plymouth/themes/xubuntu-logo/logo.png /usr/share/plymouth/themes/xubuntu-logo/logo-original.png
mv ~/InteliOS*/xfce/logo-inicio/logo.png /usr/share/plymouth/themes/xubuntu-logo/
update-initramfs -u
#
echo "# ELIMINANDO PROGRAMAS INNECESARIOS"
apt remove -y gnome-mines gnome-sudoku sgt-puzzles xfburn simple-scan mate-calc mate-calc-common yelp popularity-contest xfce4-whiskermenu-plugin
apt remove --purge -y rhythmbox libreoffice* gimp* thunderbird* hexchat* apport
apt autoremove -y
rm /usr/share/applications/xfce4-mail-reader.desktop 
rm /usr/share/applications/xfce4-web-browser.desktop 
#
echo "# CONCEDIENDO PERMISOS DE EJECUCIÓN A LOS SCRIPTS"
chmod +x /opt/OSINT-Scripts/*
#
echo "# BORRANDO ARCHIVOS DE INSTALACIÓN"
cd ~/
rm -r ~/InteliOS*/
echo "# INSTALACIÓN FINALIZADA"
