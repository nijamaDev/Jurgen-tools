#!/bin/bash
# Raise errors if any
set -e
set -x

echo Enabling NFS...
nfs_entry="192.168.26.37:/nfs  /nfs  nfs4  defaults,user,exec  0 0"

# check if the NFS entry already exists in /etc/fstab
if grep -q "$nfs_entry" /etc/fstab; then
    echo "NFS entry already exists in /etc/fstab"
else
    # if the NFS entry does not exist, then append it to /etc/fstab
    echo "$nfs_entry" | sudo tee -a /etc/fstab > /dev/null
    echo "NFS entry added to /etc/fstab"
fi

echo Enabling fastest mirror and parallel downloads on dnf...
cp ./dnf.conf /etc/dnf/

echo Enabling CRB repository...
crb enable

echo Updating the system...
dnf up --refresh -y

echo Enabling EPEL Repo...
dnf install --nogpgcheck https://dl.fedoraproject.org/pub/epel/epel-release-latest-$(rpm -E %rhel).noarch.rpm

echo Enabling RPM Fusion Free and nonfree repos...
dnf install --nogpgcheck https://mirrors.rpmfusion.org/free/el/rpmfusion-free-release-$(rpm -E %rhel).noarch.rpm https://mirrors.rpmfusion.org/nonfree/el/rpmfusion-nonfree-release-$(rpm -E %rhel).noarch.rpm

echo Instaling various codecs and utilities...
dnf groupupdate -y core
dnf groupupdate -y multimedia --setop="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin
dnf groupupdate -y sound-and-video
dnf install -y rpmfusion-free-release-tainted rpmfusion-nonfree-release-tainted
dnf in -y libdvdcss
dnf --repo=rpmfusion-nonfree-tainted install "*-firmware"

echo Set the date and time to synchronize with an NTP server
timedatectl set-ntp true

echo 'DONE'
echo 'You should REBOOT now'

