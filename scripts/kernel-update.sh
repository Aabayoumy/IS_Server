#!/bin/bash
cd /tmp

if ! which lynx > /dev/null; then sudo apt-get install lynx -y; fi

if [ "$(getconf LONG_BIT)" == "64" ]; then arch=amd64; else arch=i386; fi

function download() {
   wget $(lynx -dump -listonly -dont-wrap-pre $kernelURL | grep "$1" | grep "$2" | grep "$arch" | cut -d ' ' -f 4)
}

# Kernel URL
kernelURL=$(lynx -dump -nonumbers http://kernel.ubuntu.com/~kernel-ppa/mainline/ | grep -v rc | tail -1) 
lowlatency=0
echo "Downloading the latest generic kernel."
download generic header
download generic image

# Shared Kernel Header
wget $(lynx -dump -listonly -dont-wrap-pre $kernelURL | grep all | cut -d ' ' -f 4)

# Install Kernel
echo "Installing Linux Kernel"
sudo dpkg -i linux*.deb
echo "Done. You may now reboot."
