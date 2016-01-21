apt-get install live-build
git clone git://git.kali.org/live-build-config.git
cd live-build-config

echo “cryptsetup gparted amap” >> kali-config/variant-light/package-lists/kali.list.chroot

echo "update-rc.d -f ssh enable" >> kali-config/common/hooks/01-start-ssh.chroot
chmod 755 kali-config/common/hooks/01-start-ssh.chroot
mkdir -p kali-config/common/includes.chroot/username/.ssh/
cp ~/.ssh/id_rsa.pub kali-config/common/includes.chroot/username/.ssh/authorized_keys

echo "Okay, create the following script in another terminal... "
echo "vi kali-config/common/hooks/02-unattended-boot.binary"
echo " "
echo "Copy and paste the following: "
echo " "
echo "cat >>binary/isolinux/install.cfg < label install
menu label ^Unattended Install
menu default
linux /install/vmlinuz
initrd /install/initrd.gz
append vga=788 -- quiet file=/cdrom/install/preseed.cfg locale=en_US keymap=us hostname=kali domain=local.lan
END"

read -rsp $'Press any key to continue...\n' -n1 key

chmod 755 kali-config/common/hooks/02-unattended-boot.binary
ls -al kali-config/common/hooks/

wget https://www.kali.org/dojo/preseed.cfg -O ./kali-config/common/includes.installer/preseed.cfg
wget https://www.kali.org/dojo/wp-blue.png -O kali-config/common/includes.chroot/usr/share/images/desktop-base/kali-wallpaper_1920x1080.png

./build.sh –variant light –distribution kali-rolloing –verbose
