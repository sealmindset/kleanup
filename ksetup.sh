# Setting up Dependencies
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Update the system
apt-get -y update 

# Dist Upgrade once
if [ $(grep dist-upgrade /var/log/apt/history.log | wc -l) -lt 1 ]; then
  echo -e "${RED} [!] ${NC} Performing a Distribution Upgrade!"
  apt-get -y dist-upgrade
else
  echo -e "${GREEN} [!] ${NC} Distribution Upgrade was previously completed."
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
aptArray=(hexchat exploitdb exploitdb-papers exploitdb-bin-sploits)
installAPT "${aptArray[@]}"

# Install PhantomJS & Imagemagick
imgArray=(build-essential chrpath libssl-dev libxft-dev libfreetype6-dev libfreetype6 libfontconfig1-dev libfontconfig1 imagemagick)
installAPT "${imgArray[@]}"

if [ $(type phantomjs | wc -l) -lt 1 ]; then
  echo -e "${YELLOW} [!] ${NC} Installing phantomjs!"
  wget https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2
  tar xvjf phantomjs-2.1.1-linux-x86_64.tar.bz2 -C /usr/local/share/
  ln -s /usr/local/share/phantomjs-2.1.1-linux-x86_64/bin/phantomjs /usr/local/bin/
else
  echo -e "${GREEN} [!] ${NC} phantomjs is already installed"    
fi
