#!/bin/bash
wget -c http://us.download.nvidia.com/XFree86/Linux-x86_64/361.42/NVIDIA-Linux-x86_64-361.42.run
wget -c http://developer.download.nvidia.com/compute/cuda/7.5/Prod/local_installers/cuda_7.5.18_linux.run
chmod +x *.run
apt-get install freeglut3-dev libxmu-dev
cd ~/Downloads
modprobe -r nouveau
/etc/init.d/gdm3 stop
./NVIDIA-Linux-x86_64-361.42.run
