#!/bin/bash
#
# Description: For building out VM based Kali Linux boxes. 
#
####> Add a splash of color

RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

####> Housekeeping 
# Dist Upgrade once
if [ $(grep dist-upgrade /var/log/apt/history.log | wc -l) -lt 1 ]; then
  echo -e "${RED} [!!!] ${NC} Performing a Distribution Upgrade!"
  apt-get update && apt-get -y upgrade && apt-get -y dist-upgrade
else
  echo -e "${GREEN} [!] ${NC} A Full Dist was already completed."
  if [ $(($(date +%s) - $(date +%s -r /var/log/apt/term.log))) -gt 3600 ]; then
    echo -e "${YELLOW} [!] ${NC} Performing an apt-get update"
    apt-get update
  fi
fi

####> Useful Functions 

function installAPT() {
  arr=("$@")
  for j in "${arr[@]}";  do
    if [ $(apt-cache search ${j} | wc -l) -gt 0 ]; then
      if [ $(dpkg -s ${j} 2>/dev/null | grep Status | wc -l) -eq 0 ]; then
        echo -e "${YELLOW} [!] ${NC} Installing ${j}!"
        apt-get -y install ${j}
      else
        echo -e "${GREEN} [*] ${NC} ${j} is already installed"  
      fi
    else
      echo -e "${RED} [!!!] ${NC} ${j} cannot be installed using apt the method." 
    fi
done
}

####> Not quite PTF, but its the tools I'm using 

aptArray=(hexchat terminator exploitdb exploitdb-papers exploitdb-bin-sploits golang-go)
installAPT "${aptArray[@]}"

if [ $(type phantomjs | wc -l) -lt 1 ]; then
  echo -e "${YELLOW} [!] ${NC} Installing phantomjs!"
  imgArray=(build-essential chrpath libxft-dev libfreetype6-dev libfreetype6 libfontconfig1-dev libfontconfig1 imagemagick)
installAPT "${imgArray[@]}"
  wget https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2
  tar xvjf phantomjs-2.1.1-linux-x86_64.tar.bz2 -C /usr/local/share/
  ln -s /usr/local/share/phantomjs-2.1.1-linux-x86_64/bin/phantomjs /usr/local/bin/
else
  echo -e "${GREEN} [*] ${NC} phantomjs is already installed"    
fi

if [ -d /root/projects ]; then
  echo -e "${GREEN} [*] ${NC} Directory for projects already exists!"    
else  
  echo -e "${YELLOW} [!] ${NC} Creating the directory for projects."
  mkdir /root/projects
fi

if [ -d /root/wordlist ]; then
  echo -e "${GREEN} [*] ${NC} wordlist directory already exists!"    
  if [ -d /root/wordlist/RobotsDisallowed ]; then
    echo -e "${GREEN} [*] ${NC} RobotsDisallowed directory already exists!"    
  else
    echo -e "${YELLOW} [!] ${NC} Cloneing RobotsDisallowed ..."
    cd /root/wordlist
    git clone https://github.com/danielmiessler/RobotsDisallowed.git
  fi
  if [ -d /root/wordlist/SecLists ]; then
    echo -e "${GREEN} [*] ${NC} SecLists directory already exists!"    
  else
    echo -e "${YELLOW} [!] ${NC} Cloneing SecLists ..."
    cd /root/wordlist
    git clone https://github.com/danielmiessler/SecLists.git
  fi
else
  echo -e "${YELLOW} [!] ${NC} Creating wordlist..."
  mkdir /root/wordlist
  cd /root/wordlist
  echo -e "${YELLOW} [!] ${NC} Cloneing RobotsDisallowed ..."
  git clone https://github.com/danielmiessler/RobotsDisallowed.git
  echo -e "${YELLOW} [!] ${NC} Cloneing SecLists ..."
  git clone https://github.com/danielmiessler/SecLists.git
fi

if [ -f /usr/share/nmap/scripts/banner-plus.nse ]; then
  echo -e "${GREEN} [*] ${NC} banner-plus.nse exist! " 
else
  echo -e "${YELLOW} [*] ${NC} Grabbing banner-plus.nse... " N
  cd /root/wappass
  git clone https://github.com/hdm/scan-tools.git
  cp /root/wappass/scan-tools/nse/banner-plus.nse /usr/share/nmap/scripts/
fi

if [ -d /root/wappass/w3af ]; then
  echo -e "${GREEN} [*] ${NC} w3af is installed! " 
else
  echo -e "${YELLOW} [*] ${NC} Grabbing w3af... " N
  cd /root/wappass
  git clone https://github.com/andresriancho/w3af.git

  w3afArray=(build-essential autoconf libtool pkg-config python-opengl python-imaging python-pyrex python-pyside.qtopengl idle-python2.7 qt4-dev-tools qt4-designer libqtgui4 libqtcore4 libqt4-xml libqt4-test libqt4-script libqt4-network libqt4-dbus python-qt4 python-qt4-gl libgle3 python-dev)
  installAPT "${w3afArray[@]}"
  
  w3af2Array=(libxml2-dev libxslt1-dev zlib1g-dev)
  installAPT "${w3af2Array[@]}"
  pip install lxml==3.4.4 scapy-real==2.2.0-dev guess-language==0.2 cluster==1.1.1b3 msgpack-python==0.4.4 python-ntlm==1.0.1 halberd==0.2.4 darts.util.lru==0.5 vulndb==0.0.19 markdown==2.6.1 psutil==2.2.1 ds-store==1.1.2 termcolor==1.1.0 mitmproxy==0.13 ruamel.ordereddict==0.4.8 Flask==0.10.1 tldextract==1.7.2 pebble==4.3.6 acora==2.1 esmre==0.3.1

  cd /root/wappass/w3af/
  ./w3af_console
  ./tmp/w3af_dependency_install.sh
fi

# Not sure what the intersecs or the diffs are... yet!
#if [ -d /root/ptf ]; then
#  echo -e "${GREEN} [*] ${NC} Got PTF!"  
#else
#  echo -e "${YELLOW} [!] ${NC} Let's get some PTF!"  
#  cd /root
#  git clone https://github.com/trustedsec/ptf.git
#  echo -e "${YELLOW} [!] ${NC} cd ptf"  
#  echo -e "${YELLOW} [!] ${NC} use modules/install_updata_all"  
#fi

if [ -f /usr/bin/pwsh ]; then
  echo -e "${GREEN} [*] ${NC} PowerShell is installed! " 
else
  echo -e "${YELLOW} [*] ${NC} Grabbing PowerShell... " N
  cd /root

  psArray=(libunwind8 liblttng-ust0)
  installAPT "${psArray[@]}"

  wget http://archive.ubuntu.com/ubuntu/pool/main/i/icu/libicu55_55.1-7_amd64.deb
  dpkg -i libicu55_55.1-7_amd64.deb

  wget https://github.com/PowerShell/PowerShell/releases/download/v6.0.2/powershell_6.0.2-1.debian.9_amd64.deb
  dpkg -i powershell_6.0.2-1.debian.9_amd64.deb

  if [ -f /usr/bin/pwsh ]; then
    echo -e "${GREEN} [*] ${NC} PowerShell is installed! " 
  fi
fi

if [ -d /root/redteam/powershell/Empire ]; then
  echo -e "${GREEN} [*] ${NC} Empire Strikes Back!"  
else
  echo -e "${YELLOW} [!] ${NC} Git Empire...!"  
  pip install lxml==4.0.0
  cd /root/redteam/powershell
  git clone https://github.com/EmpireProject/Empire.git
  cd /root/redteam/powershell/Empire/setup
  ./install.sh
  ./reset.sh
fi

if [ -d /root/redteam/dnscat2 ]; then
  echo -e "${GREEN} [*] ${NC} Meow!"  
else
  echo -e "${YELLOW} [!] ${NC} Git some pussy...!"  
  dnsArray=(ruby-dev gcc)
  installAPT "${dnsArray[@]}"
  cd /root
  git clone https://github.com/iagox86/dnscat2.git
  cd /root/dnscat2/server/  
  make  
  gem install bundler
  bundle install  
  cd /root/dnscat2/client/  
  make
  echo -e "${GREEN} [!] ${NC} Test it: ruby ./dnscat2.rb"
fi

if [ $(type code | wc -l) -lt 1 ]; then
  # REM: http://www.rafaelhart.com/2017/08/install-visual-studio-code-on-kali-linux/
  echo -e "${YELLOW} [!] ${NC} Visual Studio must be installed!"
  curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
  mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
  echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list
  apt update && apt install code
  echo -e "${YELLOW} [!] ${NC} Run: code --user-data-dir=\"~/.vscode-root\""
else
  echo -e "${GREEN} [*] ${NC} We have Visual Studio installed!!"  
  echo -e "${YELLOW} [!] ${NC} Run: code --user-data-dir=\"~/.vscode-root\""
fi

if [ -f /root/redteam/shell/pupy/pupy/pupysh.py ]; then
  echo -e "${GREEN} [!] ${NC}  Good pupy!"
else
  echo -e "${YELLOW} [!] ${NC} Here pupy pupy!"
  cd /root/redteam/shell/pupy
  git clone https://github.com/n1nj4sec/pupy
  git submodule init
  git submodule update
  pip install -r pupy/requirements.txt
  wget https://github.com/n1nj4sec/pupy/releases/download/latest/payload_templates.txz
  tar xvf payload_templates.txz
  mv payload_templates/* pupy/payload_templates/
  rm payload_templates.txz
  rm -r payload_templates
fi

if [ -d /root/redteam/powershell/p0wnedShell ]; then
  echo -e "${GREEN} [*] ${NC} I feel the p0wnedShell!"  
else
  echo -e "${YELLOW} [!] ${NC} I need p0wnedShell!"
  cd /root/redteam/powershell
  git clone https://github.com/Cn33liz/p0wnedShell
fi

if [ -d /root/redteam/powershell/nishang ]; then
  echo -e "${GREEN} [*] ${NC} Got nishang!"  
else
  echo -e "${YELLOW} [!] ${NC} git nishang!"
  cd /root/redteam/powershell
  git clone https://github.com/samratashok/nishang
fi

if [ -d /root/redteam/powershell/PoshC2 ]; then
  echo -e "${GREEN} [*] ${NC} This PoshC2!"  
else
  echo -e "${YELLOW} [!] ${NC} Need more PoshC2!"
  cd /root/redteam/powershell
  git clone https://github.com/nettitude/PoshC2
fi

if [ -d /root/redteam/tunnels ]; then
  echo -e "${GREEN} [*] ${NC} Can tunnel thru ICMP"  
else
  echo -e "${YELLOW} [!] ${NC} Need to build some ICMP tunnels!"
  cd /root/redteam/tunnels
  git clone https://github.com/inquisb/icmpsh
  git clone https://github.com/friedrich/hans.git
  git clone https://github.com/jamesbarlow/icmptunnel
  git clone https://github.com/DhavalKapil/icmptunnel icmptunnel2
  git clone https://github.com/Ne0nd0g/merlin
fi

####> Recon Tools 

if [ -d /root/redteam/recon/httpscreenshot ]; then
  echo -e "${GREEN} [*] ${NC} httpscreenshot!"  
else
  echo -e "${YELLOW} [!] ${NC} Git httpscreenshot!"
  cd /root/redteam/recon/
  git clone https://github.com/breenmachine/httpscreenshot
  cd /root/redteam/recon/httpscreenhot
  ./install-dependencies.sh
  chmod +x *.py
fi

if [ -d /root/redteam/recon/EyeWitness ]; then
  echo -e "${GREEN} [*] ${NC} EyeWitness!"  
else
  echo -e "${YELLOW} [!] ${NC} Git EyeWitness!"
  cd /root/redteam/recon/
  git clone https://github.com/ChrisTruncer/EyeWitness
  cd /root/redteam/recon/EyeWitness/setup
  ./setup.sh
fi

####> My toolbag

if [ -d /root/oscp ]; then
  echo -e "${GREEN} [*] ${NC} Updating OSCP!"  
  cd /root/oscp
  git pull
else
  echo -e "${YELLOW} [!] ${NC} Grabbing the OSCP toolbox!"
  cd /root
  git clone https://github.com/sealmindset/oscp
fi

####> Kali Preferences

if grep -q '^#.* AutomaticLogin' /etc/gdm3/daemon.conf; then
  echo -e "${YELLOW} [!] ${NC} Setting up Autologin..."
  sed -i '/^#.* AutomaticLogin/s/^#//' /etc/gdm3/daemon.conf
else
  echo -e "${GREEN} [*] ${NC} Autologin is already set."
fi

if grep -q '^disable_lua\ \= false' /etc/wireshark/init.lua; then
  echo -e "${YELLOW} [!] ${NC} Setting Wireshark lua to true..."
  sed -i '/^disable_lua\ \= false/s/false/true/' /etc/wireshark/init.lua
else
  echo -e "${GREEN} [*] ${NC} Wireshark lua is already set."
fi

####> Done 

echo -e "${GREEN} [*] ${NC} Now go hack something... (legally)"
