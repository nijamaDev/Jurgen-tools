#!/bin/bash
# Enable fastest mirror and multidownload on dnf
cp ./dnf.conf /etc/dnf/

# Enable repositories
dnf config-manager --set-enabled ha nfv plus powertools resilient-storage rt

# Update the system
dnf up --refresh -y

# Enable and configure RPM Fusion repositories also install codecs and firmware
dnf install -y --nogpgcheck https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
dnf install -y --nogpgcheck https://mirrors.rpmfusion.org/free/el/rpmfusion-free-release-8.noarch.rpm https://mirrors.rpmfusion.org/nonfree/el/rpmfusion-nonfree-release-8.noarch.rpm
dnf groupupdate -y core
dnf groupupdate -y multimedia --setop="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin
dnf groupupdate -y sound-and-video
dnf install -y rpmfusion-free-release-tainted rpmfusion-nonfree-release-tainted
dnf in -y libdvdcss \*-firmware

# Set the date and time to synchronize with an NTP server
timedatectl set-ntp true

echo ''
echo 'You should REBOOT now'

