#!/bin/bash
#
# BASH. It's what I know best, sorry.
#
# set some defaults
: ${PARALLEL_JOBS:=18}
: ${PARALLEL:="parallel"}
# urls
UBUNTU_1604_MINI_URL='http://archive.ubuntu.com/ubuntu/dists/xenial-updates/main/installer-amd64/current/images/hwe-netboot/mini.iso'
UBUNTU_1804_MINI_URL='http://archive.ubuntu.com/ubuntu/dists/bionic/main/installer-amd64/current/images/netboot/mini.iso'
UBUNTU_1810_MINI_URL='http://archive.ubuntu.com/ubuntu/dists/cosmic-updates/main/installer-amd64/current/images/netboot/mini.iso'
UBUNTU_1904_MINI_URL='http://archive.ubuntu.com/ubuntu/dists/disco/main/installer-amd64/current/images/netboot/mini.iso'
UBUNTU_1804_ISO_URL='http://releases.ubuntu.com/18.04.1/ubuntu-18.04.1-desktop-amd64.iso http://reflection.oss.ou.edu/ubuntu-release/18.04.1/ubuntu-18.04.1-desktop-amd64.iso'
UBUNTU_1804_SERVER_ISO_URL='http://releases.ubuntu.com/18.04.1/ubuntu-18.04.1.0-live-server-amd64.iso http://reflection.oss.ou.edu/ubuntu-release/18.04.1/ubuntu-18.04.1.0-live-server-amd64.iso'
UBUNTU_1810_ISO_URL='http://releases.ubuntu.com/18.10/ubuntu-18.10-desktop-amd64.iso http://reflection.oss.ou.edu/ubuntu-release/18.10/ubuntu-18.10-desktop-amd64.iso'
UBUNTU_1810_SERVER_ISO_URL='http://releases.ubuntu.com/18.10/ubuntu-18.10-live-server-amd64.iso http://reflection.oss.ou.edu/ubuntu-release/18.10/ubuntu-18.10-live-server-amd64.iso'
CENTOS_7_LIVE_KDE='http://repos.dfw.quadranet.com/centos/7.6.1810/isos/x86_64/CentOS-7-x86_64-LiveKDE-1810.iso http://yum.tamu.edu/centos/7.6.1810/isos/x86_64/CentOS-7-x86_64-LiveKDE-1810.iso http://mirror.dal10.us.leaseweb.net/centos/7.6.1810/isos/x86_64/CentOS-7-x86_64-LiveKDE-1810.iso'
CENTOS_7_LIVE_GNOME='http://repos.dfw.quadranet.com/centos/7.6.1810/isos/x86_64/CentOS-7-x86_64-LiveGNOME-1810.iso http://yum.tamu.edu/centos/7.6.1810/isos/x86_64/CentOS-7-x86_64-LiveGNOME-1810.iso http://mirror.dal10.us.leaseweb.net/centos/7.6.1810/isos/x86_64/CentOS-7-x86_64-LiveGNOME-1810.iso'
CENTOS_7_NET='http://repos-tx.psychz.net/centos/7.6.1810/isos/x86_64/CentOS-7-x86_64-NetInstall-1810.torrent'
ARCH_MAGNET='magnet:?xt=urn:btih:f42055fd45cf195cac68f242d1177c5a5b6162d5&dn=archlinux-2019.05.02-x86_64.iso&tr=udp://tracker.archlinux.org:6969&tr=http://tracker.archlinux.org:6969/announce'
ANTERGOS_TORRENT='http://mirrors.antergos.com/iso/release/antergos-18.12-x86_64.iso.torrent'
CLONEZILLA_URL='https://osdn.net/frs/redir.php?m=pumath&f=clonezilla%2F71030%2Fclonezilla-live-2.6.1-25-amd64.iso https://downloads.sourceforge.net/project/clonezilla/clonezilla_live_stable/2.6.1-25/clonezilla-live-2.6.1-25-amd64.iso?r=https%3A%2F%2Fsourceforge.net%2Fprojects%2Fclonezilla%2Ffiles%2Fclonezilla_live_stable%2F2.6.1-25%2Fclonezilla-live-2.6.1-25-amd64.iso%2Fdownload%3Fuse_mirror%3Diweb&ts=1558800811'
CLONEZILLA_32_URL='https://osdn.net/frs/redir.php?m=constant&f=clonezilla%2F69912%2Fclonezilla-live-2.5.6-22-i686.iso'
DEBIAN_LIVE_CINNAMON_TORRENT='https://cdimage.debian.org/debian-cd/current-live/amd64/bt-hybrid/debian-live-9.6.0-amd64-cinnamon.iso.torrent'
DEBIAN_LIVE_GNOME_TORRENT='https://cdimage.debian.org/debian-cd/current-live/amd64/bt-hybrid/debian-live-9.6.0-amd64-gnome.iso.torrent'
DEBIAN_LIVE_KDE_TORRENT='https://cdimage.debian.org/debian-cd/current-live/amd64/bt-hybrid/debian-live-9.6.0-amd64-kde.iso.torrent'
DEBIAN_LIVE_LXDE_TORRENT='https://cdimage.debian.org/debian-cd/current-live/amd64/bt-hybrid/debian-live-9.6.0-amd64-lxde.iso.torrent'
DEBIAN_LIVE_MATE_TORRENT='https://cdimage.debian.org/debian-cd/current-live/amd64/bt-hybrid/debian-live-9.6.0-amd64-mate.iso.torrent'
DEBIAN_LIVE_XFCE_TORRENT='https://cdimage.debian.org/debian-cd/current-live/amd64/bt-hybrid/debian-live-9.6.0-amd64-xfce.iso.torrent'
DEBIAN_NETINST_TORRENT='https://cdimage.debian.org/debian-cd/current/amd64/bt-cd/debian-9.6.0-amd64-netinst.iso.torrent'
DEBIAN_MINI_URL='http://ftp.debian.org/debian/dists/stretch/main/installer-amd64/current/images/netboot/mini.iso'
BODHI_TORRENT='http://sourceforge.net/projects/bodhilinux/files/5.0.0/bodhi-5.0.0-64.iso.torrent/download'
BODHI_APPPACK='http://sourceforge.net/projects/bodhilinux/files/5.0.0/bodhi-5.0.0-apppack-64.iso.torrent/download'
BODHI_LEGACY='http://sourceforge.net/projects/bodhilinux/files/5.0.0/bodhi-5.0.0-apppack-64.iso.torrent/download'
GPARTED_URL='https://sourceforge.net/projects/gparted/files/gparted-live-stable/0.33.0-1/gparted-live-0.33.0-1-amd64.iso/download?use_mirror=superb-dca2#'
KALI_TORRENT='https://images.offensive-security.com/kali-linux-2019.2-amd64.iso.torrent'
TAILS_TORRENT='https://tails.boum.org/torrents/files/tails-amd64-3.14.iso.torrent'
SYSRESCUECD_URL='https://osdn.net/frs/redir.php?m=xtom_us&f=%2Fstorage%2Fg%2Fs%2Fsy%2Fsystemrescuecd%2Freleases%2F6.0.3%2Fsystemrescuecd-6.0.3.iso'
ENDIAN_URL='https://downloads.sourceforge.net/project/efw/Development/EFW-3.3.0/efw_community-x64_3.3.0_recovery_softwarex86-64_20181026164637.iso?r=https%3A%2F%2Fsourceforge.net%2Fprojects%2Fefw%2Ffiles%2FDevelopment%2FEFW-3.3.0%2Fefw_community-x64_3.3.0_recovery_softwarex86-64_20181026164637.iso%2Fdownload&ts=1558804920 https://sourceforge.net/projects/efw/files/Development/EFW-3.3.0/efw_community-x64_3.3.0_recovery_softwarex86-64_20181026164637.iso/download#'
THIS_CWD=$(pwd)

check_cmd () {
  if ! type "$1" > /dev/null; then
    echo "$1 was not found in your path!"
    echo "To proceed please install $1 to your path and try again!"
    exit 1
  fi
}

source inc/utils
# Get serious. If we get here, things are looking sane
#

# Sanity check : human will read the info and confirm
read -n 1 -s -p "Ready to install GLIM isoz. Continue? (Y/n) " PROCEED
if [[ "$PROCEED" == "n" ]]; then
  echo "n"
  exit 2
else
  echo "y"
fi

if [[ -z "${USBMNT}" ]]; then
    echo USBMNT var is empty
    exit 1
fi
# Check USB mount dir write permission, to use sudo if missing
if [[ -w "${USBMNT}" ]]; then
  CMD_PREFIX=""
else
  CMD_PREFIX="sudo"
fi

check_cmd aria2c
check_cmd parallel

TMP=$(mktemp -d --suffix='.glim.dl.tmp' 2>/dev/null || mktemp -d -t '.glim.dl.tmp')

$CMD_PREFIX mkdir -p ${USBMNT}/boot/iso/ubuntu/xenial
$CMD_PREFIX mkdir -p ${USBMNT}/boot/iso/ubuntu/bionic
$CMD_PREFIX mkdir -p ${USBMNT}/boot/iso/ubuntu/cosmic
$CMD_PREFIX mkdir -p ${USBMNT}/boot/iso/ubuntu/disco
$CMD_PREFIX mkdir -p ${USBMNT}/boot/iso/centos
$CMD_PREFIX mkdir -p ${USBMNT}/boot/iso/arch
$CMD_PREFIX mkdir -p ${USBMNT}/boot/iso/antix
$CMD_PREFIX mkdir -p ${USBMNT}/boot/iso/clonezilla
$CMD_PREFIX mkdir -p ${USBMNT}/boot/iso/debian
$CMD_PREFIX mkdir -p ${USBMNT}/boot/iso/gparted
$CMD_PREFIX mkdir -p ${USBMNT}/boot/iso/bodhi
$CMD_PREFIX mkdir -p ${USBMNT}/boot/iso/kali
$CMD_PREFIX mkdir -p ${USBMNT}/boot/iso/tails
$CMD_PREFIX mkdir -p ${USBMNT}/boot/iso/endian

# prep downloads
echo "$CMD_PREFIX aria2c -x2 -c --dir ${USBMNT}/boot/iso/ubuntu/xenial $UBUNTU_1604_MINI_URL" >> $TMP/parallel-dl.sh
echo "$CMD_PREFIX aria2c -x2 -c --dir ${USBMNT}/boot/iso/ubuntu/bionic $UBUNTU_1804_MINI_URL" >> $TMP/parallel-dl.sh
echo "$CMD_PREFIX aria2c -x2 -c --dir ${USBMNT}/boot/iso/ubuntu/cosmic $UBUNTU_1810_MINI_URL" >> $TMP/parallel-dl.sh
echo "$CMD_PREFIX aria2c -x2 -c --dir ${USBMNT}/boot/iso/ubuntu/disco $UBUNTU_1904_MINI_URL" >> $TMP/parallel-dl.sh
#echo "$CMD_PREFIX aria2c -x2 -c --dir ${USBMNT}/boot/iso/ubuntu $UBUNTU_1804_ISO_URL" >> $TMP/parallel-dl.sh
#echo "$CMD_PREFIX aria2c -x2 -c --dir ${USBMNT}/boot/iso/ubuntu $UBUNTU_1804_SERVER_ISO_URL" >> $TMP/parallel-dl.sh
#echo "$CMD_PREFIX aria2c -x2 -c --dir ${USBMNT}/boot/iso/ubuntu $UBUNTU_1810_ISO_URL" >> $TMP/parallel-dl.sh
#echo "$CMD_PREFIX aria2c -x2 -c --dir ${USBMNT}/boot/iso/ubuntu $UBUNTU_1810_SERVER_ISO_URL" >> $TMP/parallel-dl.sh
#echo "$CMD_PREFIX aria2c -x2 -c --dir ${USBMNT}/boot/iso/centos $CENTOS_7_DVD" >> $TMP/parallel-dl.sh
#echo "$CMD_PREFIX aria2c -x2 -c --dir ${USBMNT}/boot/iso/centos $CENTOS_7_LIVE_KDE" >> $TMP/parallel-dl.sh
#echo "$CMD_PREFIX aria2c -x2 -c --dir ${USBMNT}/boot/iso/centos $CENTOS_7_LIVE_GNOME" >> $TMP/parallel-dl.sh
echo "$CMD_PREFIX aria2c -x2 -c --dir ${USBMNT}/boot/iso/centos $CENTOS_7_NET" >> $TMP/parallel-dl.sh
echo "$CMD_PREFIX aria2c --seed-time=1 --seed-ratio=1.0 -c --dir ${USBMNT}/boot/iso/arch --follow-torrent=mem $ARCH_MAGNET" >> $TMP/parallel-dl.sh
#echo "$CMD_PREFIX aria2c --dir ${USBMNT}/boot/iso/antix --seed-time=1 --seed-ratio=1.0 -c --follow-torrent=mem -T$THIS_CWD/torrents/antiX-17.3.1_x64-full.torrent" >> $TMP/parallel-dl.sh
#echo "$CMD_PREFIX aria2c --dir ${USBMNT}/boot/iso/antix --seed-time=1 --seed-ratio=1.0 -c --follow-torrent=mem -T$THIS_CWD/torrents/antiX-17.3.1_386-full.torrent" >> $TMP/parallel-dl.sh
echo "$CMD_PREFIX aria2c -x2 -c --dir ${USBMNT}/boot/iso/clonezilla $CLONEZILLA_URL" >> $TMP/parallel-dl.sh
#echo "$CMD_PREFIX aria2c -x2 -c --dir ${USBMNT}/boot/iso/clonezilla $CLONEZILLA_32_URL" >> $TMP/parallel-dl.sh
#echo "$CMD_PREFIX aria2c --dir ${USBMNT}/boot/iso/debian --seed-time=1 --seed-ratio=1.0 -c --follow-torrent=mem $DEBIAN_LIVE_CINNAMON_TORRENT" >> $TMP/parallel-dl.sh
#echo "$CMD_PREFIX aria2c --dir ${USBMNT}/boot/iso/debian --seed-time=1 --seed-ratio=1.0 -c --follow-torrent=mem $DEBIAN_LIVE_GNOME_TORRENT" >> $TMP/parallel-dl.sh
#echo "$CMD_PREFIX aria2c --dir ${USBMNT}/boot/iso/debian --seed-time=1 --seed-ratio=1.0 -c --follow-torrent=mem $DEBIAN_LIVE_KDE_TORRENT" >> $TMP/parallel-dl.sh
#echo "$CMD_PREFIX aria2c --dir ${USBMNT}/boot/iso/debian --seed-time=1 --seed-ratio=1.0 -c --follow-torrent=mem $DEBIAN_LIVE_LXDE_TORRENT" >> $TMP/parallel-dl.sh
#echo "$CMD_PREFIX aria2c --dir ${USBMNT}/boot/iso/debian --seed-time=1 --seed-ratio=1.0 -c --follow-torrent=mem $DEBIAN_LIVE_MATE_TORRENT" >> $TMP/parallel-dl.sh
#echo "$CMD_PREFIX aria2c --dir ${USBMNT}/boot/iso/debian --seed-time=1 --seed-ratio=1.0 -c --follow-torrent=mem $DEBIAN_LIVE_XFCE_TORRENT" >> $TMP/parallel-dl.sh
#echo "$CMD_PREFIX aria2c --dir ${USBMNT}/boot/iso/debian --seed-time=1 --seed-ratio=1.0 -c --follow-torrent=mem $DEBIAN_NETINST_TORRENT" >> $TMP/parallel-dl.sh
echo "$CMD_PREFIX aria2c --dir ${USBMNT}/boot/iso/debian -x2 -c $DEBIAN_MINI_URL" >> $TMP/parallel-dl.sh
echo "$CMD_PREFIX aria2c --dir ${USBMNT}/boot/iso/bodhi --seed-time=1 --seed-ratio=1.0 -c --follow-torrent=mem $BODHI_TORRENT" >> $TMP/parallel-dl.sh
#echo "$CMD_PREFIX aria2c --dir ${USBMNT}/boot/iso/bodhi --seed-time=1 --seed-ratio=1.0 -c --follow-torrent=mem $BODHI_APPPACK" >> $TMP/parallel-dl.sh
#echo "$CMD_PREFIX aria2c --dir ${USBMNT}/boot/iso/bodhi --seed-time=1 --seed-ratio=1.0 -c --follow-torrent=mem $BODHI_LEGACY" >> $TMP/parallel-dl.sh
echo "$CMD_PREFIX aria2c --dir ${USBMNT}/boot/iso/gparted -x2 -c $GPARTED_URL" >> $TMP/parallel-dl.sh
echo "$CMD_PREFIX aria2c --dir ${USBMNT}/boot/iso/kali --seed-time=1 --seed-ratio=1.0 -c --follow-torrent=mem $KALI_TORRENT" >> $TMP/parallel-dl.sh
echo "$CMD_PREFIX aria2c --dir ${USBMNT}/boot/iso/tails --seed-time=1 --seed-ratio=1.0 -c --follow-torrent=mem $TAILS_TORRENT" >> $TMP/parallel-dl.sh
echo "$CMD_PREFIX aria2c -x2 -c --dir ${USBMNT}/boot/iso/endian $ENDIAN_URL" >> $TMP/parallel-dl.sh

shuf -o $TMP/parallel-dl.shuf $TMP/parallel-dl.sh
mv $TMP/parallel-dl.shuf $TMP/parallel-dl.sh
cat $TMP/parallel-dl.sh

if [[ "$PARALLEL_JOBS" -gt "1" ]] ; then
  $PARALLEL -j $PARALLEL_JOBS -- < $TMP/parallel-dl.sh
else
  bash $TMP/parallel-dl.sh
fi

rm $TMP/parallel-dl.sh
rmdir $TMP

cd ${USBMNT}/boot/iso/centos
find . -iname '*.iso' | xargs -n1 -I% ln -s % ./
cd ${USBMNT}/boot/iso/ubuntu
ln -s bionic/mini.iso ./
cd ${USBMNT}/boot/iso/kali
find . -iname '*.iso' | xargs -n1 -I% ln -s % ./
