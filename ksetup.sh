# Setting up Dependencies
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Dist Upgrade once
if [ $(grep dist-upgrade /var/log/apt/history.log | wc -l) -lt 1 ]; then
  echo -e "${RED} [!!!] ${NC} Performing a Distribution Upgrade!"
  apt-get update && apt-get -y upgrade && apt-get -y dist-upgrade
else
  echo -e "${GREEN} [!] ${NC} A Full Dist was already completed."
  if [ $(($(date +%s) - $(date +%s -r /var/log/apt/term.log))) -gt 3600 ]; then
    echo -e "${YELLOW} [!] ${NC} Do a apt-get update"
    apt-get update
  fi
fi

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

# Install bare
aptArray=(hexchat libssl1.0-dev exploitdb exploitdb-papers exploitdb-bin-sploits)
installAPT "${aptArray[@]}"

# Install PhantomJS & Imagemagick
imgArray=(build-essential chrpath libssl-dev libxft-dev libfreetype6-dev libfreetype6 libfontconfig1-dev libfontconfig1 imagemagick)
installAPT "${imgArray[@]}"

trmArray=(terminator)
installAPT "${trmArray[@]}"


if [ $(type phantomjs | wc -l) -lt 1 ]; then
  echo -e "${YELLOW} [!] ${NC} Installing phantomjs!"
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

if [ -d /root/oscp ]; then
  echo -e "${GREEN} [*] ${NC} OSCP directory already exists!"  
else
  echo -e "${YELLOW} [!] ${NC} Grabbing the OSCP toolbox!"
  cd /root
  git clone https://github.com/sealmindset/oscp
fi

apt-get autoclean
apt-get autoremove

echo -e "${GREEN} [*] ${NC} Now go hack something... (legally)"
cd /root/oscp

echo -e "${GREEN} [*] ${NC} Setting up Autologin... (legally)"
sed -i '/^#.* AutomaticLogin/s/^#//' /etc/gdm3/daemon.conf

reboot
