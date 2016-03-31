#!/bin/bash

ulimit -n 1024000
ulimit -Hn 1024000
ulimit -Sn 1024000

function postVPN {
	gnome-terminal -e htop
	gnome-terminal -e iftop
	gnome-terminal --working-directory=/data/lab/results 
	gnome-terminal --working-directory=/data/lab/scripts/oscp 

	if [ $(ps ax | grep vmware-vmx | grep -v grep | wc -l) -lt 1 ]; then 
		vmrun -T player start "${PWD}/vm/Offsec PWK VM.vmx"
	fi
	if [ $(ps ax | grep iceweasel | grep -v grep | wc -l) -lt 1 ]; then 
		iceweasel 'https://10.70.70.70/oscpanel/labcpanel.php?md=b65c572dd9b210b3dff52be9b4c7997b&pid=189465&servers=1'&
	fi
}

function chkVPN {
tcpdump -i $(ifconfig | grep tap | cut -d":" -f1) not arp and not rarp and not 'tcp[13] & 4!=0' 
}

if [ $(type vmrun | wc -l) -lt 1 ]; then
	echo -e '\e[01;33m[i]\e[00m vmrun is not available'
	echo -e 'Go to https://my.vmware.com/web/vmware/free#desktop_end_user_computing/vmware_workstation_player/12_0|PLAYER-1200|drivers_tools'
	echo -e 'to download the API'
	iceweasel 'https://my.vmware.com/web/vmware/free#desktop_end_user_computing/vmware_workstation_player/12_0|PLAYER-1200|drivers_tools'
	exit
fi

if [ $(ifconfig | grep tap | cut -d":" -f1 | wc -l) -lt 1 ]; then
echo -e '\e[01;33m[i]\e[00m Connecting to the lab...'
cd /data/lab
./openlab
postVPN
chkVPN
else
if [ $(ifconfig | grep tap | cut -d":" -f1 | wc -l) -ge 1 ]; then
echo -e '\e[01;33m[i]\e[00m Already connected to the lab...'
postVPN
./t.sh
fi
fi
