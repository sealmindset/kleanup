# Setting up Dependencies

# Update the system
apt-get -y update 

# Dist Upgrade once
if [ $(grep dist-upgrade /var/log/apt/history.log | wc -l) -lt 1 ]; then
  apt-get -y dist-upgrade
if

# Install HexChat
if [ $(type hexchat | wc -l) -lt 1 ]; then
  echo 'hexchat is not installed.'
  apt-get -y install hexchat
fi

# Install PhantomJS & Imagemagick
imgArray=(build-essential chrpath libssl-dev libxft-dev libfreetype6-dev libfreetype6 libfontconfig1-dev libfontconfig1 imagemagick)

for i in "${imgArray[@]}";  do
if [ $(type $i | wc -l) -lt 1 ]; then
  echo '$i is not installed.'
  apt-get -y install $i
fi
done

if [ $(type phantomjs | wc -l) -lt 1 ]; then
  echo 'phantomjs is not installed.'
  wget https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2
  tar xvjf phantomjs-2.1.1-linux-x86_64.tar.bz2 -C /usr/local/share/
  ln -s /usr/local/share/phantomjs-2.1.1-linux-x86_64/bin/phantomjs /usr/local/bin/
fi
