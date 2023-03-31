#!/bin/bash

# Check if running from root
if [ $EUID -ne 0 ]; then
  echo -e "\033[0;31mError: This script must be run as root.\nYou can run with sudo or use 'sudo -i' to switch to the root user.\033[0m" 
  exit 1
fi

# alias to print the progress
shopt -s expand_aliases
alias echo='{ set +x; } 2>/dev/null ; echo'

# Raise errors if any
set -e
set -x

(echo Set the date and time to synchronize with an NTP server)
timedatectl set-ntp true

(echo Setting directory...)
directory=$(dirname $(readlink -f $0))

(echo Installing policies...)
groupadd noshutdown
cp $directory/Policies/* /etc/polkit-1/localauthority/50-local.d/

(echo Disabling Wayland...)
sed -i 's/#WaylandEnable=false/WaylandEnable=false/' /etc/gdm/custom.conf

(echo Enabling NFS...)
nfs_entry="192.168.26.37:/nfs  /nfs  nfs4  defaults,user,exec  0 0"

# check if the NFS entry already exists in /etc/fstab
if grep -q "$nfs_entry" /etc/fstab; then
    (echo "NFS entry already exists in /etc/fstab")
else
    # if the NFS entry does not exist, then append it to /etc/fstab
    (echo "$nfs_entry" | tee -a /etc/fstab > /dev/null)
    (echo "NFS entry added to /etc/fstab")
fi

(echo Enabling fastest mirror and parallel downloads on dnf...)
cp $directory/Configs/dnf.conf /etc/dnf/

(echo Updating the system...)
dnf up --refresh -y

(echo Enabling EPEL Repo...)
dnf in --nogpgcheck -y \
https://dl.fedoraproject.org/pub/epel/epel-release-latest-$(rpm -E %rhel).noarch.rpm

(echo Enabling CRB repository...)
crb enable

(echo Enabling RPM Fusion Free and nonfree repos...)
dnf in --nogpgcheck -y \
https://mirrors.rpmfusion.org/free/el/rpmfusion-free-release-$(rpm -E %rhel).noarch.rpm \
https://mirrors.rpmfusion.org/nonfree/el/rpmfusion-nonfree-release-$(rpm -E %rhel).noarch.rpm

(echo Instaling various codecs and utilities...)
dnf groupupdate -y core
dnf groupupdate -y multimedia --setop="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin
dnf groupupdate -y sound-and-video
dnf in -y rpmfusion-free-release-tainted rpmfusion-nonfree-release-tainted
dnf in -y libdvdcss
dnf in -y \*-firmware || true
dnf in \
btop \
htop \
chrony \
gnuplot \
ImageMagick \
mlocate \
nano \
nfs-utils \
screen \
rsync \
tar \
texlive-scheme-basic \
wget \
-y

(echo Enable flathub and add Apps...)
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install flathub \
cc.arduino.arduinoide \
com.sublimetext.three \
com.visualstudio.code \
com.wps.Office \
org.blender.Blender \
org.chromium.Chromium \
org.kde.okular \
org.gimp.GIMP \
org.inkscape.Inkscape \
org.scilab.Scilab \
-y

(echo 'DONE')
(echo 'You should REBOOT now')

