#!/bin/bash
#
# Metasploit initial setup after fresh install
#
ask() {
    while true; do
        if [ "${2:-}" = "Y" ]; then
            prompt="Y/n"
            default=Y
        elif [ "${2:-}" = "N" ]; then
            prompt="y/N"
            default=N
        else
            prompt="y/n"
            default=
        fi
        # Ask the question - use /dev/tty in case stdin is redirected from somewhere else
        read -p "$1 [$prompt] " REPLY </dev/tty
        # Default?
        if [ -z "$REPLY" ]; then
            REPLY=$default
        fi
        # Check if the reply is valid
        case "$REPLY" in
            Y*|y*) return 0 ;;
            N*|n*) return 1 ;;
        esac
    done
}
chkpkgs() {
    if [ $# > 0 ]; then
        arrayPKG=( $@ )
    else
        arrayPKG=( postgresql metasploit-framework ) 
    fi
    # Check if certain packages are installed
    for pkgname in "${arrayPKG[@]}"
    do
        if [ $(dpkg-query -W -f='${Status}' $pkgname 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
            echo "apt-get install $pkgname"
        else
            echo "$pkgname is installed"
        fi
    done
}
chkpsql () {
    # Check if postgresql is started
    if [ $(ps -ef | grep -v grep | grep postgres | wc -l) > 0 ]; then
        echo "Postgresql has been already started"
    else
        echo "Postgresql has not been started"
        service postgresql start
        update-rc.d postgresql defaults    
    fi    
}
chkmsf () {
    if [ $(sudo -u postgres -H -- psql -l | grep msf | wc -l) > 0 ]; then
        echo "msfdb has already been installed"
    else
        echo "Setting up msfdb now"
        msfdb init
    fi
}
# Check if the necessary packages are installed
chkpkgs postgresql
# Check if Metasploit is even installed
if [ $(type msfconsole | wc -l) > 0 ]; then
    # Check if postgresql is started
    chkpsql
    # Check if the msfdb install installed
    chkmsf
else
    echo "Metasploit doesn't appear to be installed"
    if [ $(apt-cache search metasploit | grep metasploit-framework | wc -l) > 0]; then
        # Default to No if the user presses enter without giving an answer:
        if ask "Do you want to install Metasploit now [y|N]?" N; then
            echo "Okay, I'll try to take care of it, installing..."
            chkpkgs postgresql metasploit-framework
            setpsql
            chkmsf
        else
            echo "No problem. C'ya!"
            exit
        fi
    else
        echo "Metasploit doesn't appear to be available on this distro"
        echo "There's nothing else to do. C'ya!"
        exit
    fi
fi
