#!/bin/bash

#clear

# ToDo List
# ToDo - a way to delete old/previous ISO versions
# ToDo - check if all inc-*.cfg are used in grub.cfg ?
# ToDo - add opensuse, mageia, Sabayon
#http://software.opensuse.org/132/nl
#https://www.mageia.org/nl/downloads/
# ToDo ? setup GRUB on the usb-stick
#   export USBMNT=/run/media/username/GLIM/
#   export USBDEV=sdb
#   sudo grub2-install --boot-directory=${USBMNT:-/mnt}/boot /dev/${USBDEV}

#
## Functions

function contains() {
	local n=$#
	local value=${!n}
	for ((i=1;i < $#;i++)) {
		if [ "${!i}" == "${value}" ]; then
			echo "y"
			return 0
		fi
	}
	echo "n"
	return 1
}


#
## Loop

if [ ! -f ./glim_update.conf ] || [ "$1" == "-c" ]
then
	# ToDo - use values from existing config file as default when -c is used

	read -e -p "USB-mount-point: " USBDIR
	if [ "$USBDIR" == "" ]
	then
		echo "USB-mount-point is empty."
		exit
	elif [ ! -d $USBDIR ]
	then
		echo "USB-mount-point [$USBDIR] does not exist."
		exit
	fi

	CURDIR=`pwd`
	read -e -p "GLIM-dir [$CURDIR]: " GLIMDIR
	if [ "$GLIMDIR" == "" ]
	then
		GLIMDIR="$CURDIR"
	elif [ ! -d $GLIMDIR ]
	then
		echo "GLIM-dir [$GLIMDIR] does not exist."
		exit
	fi

	ISODIR="$USBDIR/boot/iso"

	if [ $(which dialog) == "" ]
	then
		GLIMDIALOG="0"
	else
		read -e -p "Use DIALOG [Y/n]: " usedialog </dev/tty
		if [ "$usedialog" != "n" ] && [ "$usedialog" != "N" ]
		then
			GLIMDIALOG="1"
		else
			GLIMDIALOG="0"
		fi
	fi

	# ToDo - remove trailing slash ? (not needed but looks better..)

	echo "# glim_update config" > ./glim_update.conf
	echo "GLIMDIR=$GLIMDIR" >> ./glim_update.conf
	echo "USBDIR=$USBDIR" >> ./glim_update.conf
	echo "ISODIR=$ISODIR" >> ./glim_update.conf
	echo "GLIMDIALOG=\"$GLIMDIALOG\"" >> ./glim_update.conf
else
	. ./glim_update.conf
fi

# check for $GLIMDIR $USBDIR and $ISODIR
if [ ! -d $GLIMDIR ] || [ "$GLIMDIR" == "" ]
then
	echo "GLIMDIR not defined or does not exist [$GLIMDIR] run '$0 -c' to reconfigure"
	exit
fi
if [ ! -d $USBDIR ] || [ "$USBDIR" == "" ]
then
	echo "USBDIR not defined or does not exist [$USBDIR] run '$0 -c' to reconfigure"
	exit
fi
if [ ! -d $ISODIR ]
then
	mkdir -p $ISODIR
fi
if [ "$GLIMDIALOG" == "" ]
then
	echo "GLIMDIALOG not defined, run '$0 -c' to reconfigure"
	exit
fi
if [ "$GLIMDIALOG" != "0" ] && [ "$GLIMDIALOG" != "1" ]
then
	echo "GLIMDIALOG wrongly configured [$GLIMDIALOG] run '$0 -c' to reconfigure"
	exit
fi

# find the longest iso name
maxl=0
for incfile in `ls $GLIMDIR/grub2/inc*\.cfg`
do
	while read line
	do
		if [[ "$line" == *isoname=* ]]
		then
			name=`echo "$line"|cut -d'"' -f2`
			if [ "${#name}" -gt "$maxl" ]
			then
				maxl=${#name}
			fi
		fi
	done < <(grep 'isoname=' $incfile | grep -v '#')
done

# ToDo - check if grub2 has been installed in the USBDIR

rsync -a $GLIMDIR/grub2/ $USBDIR/boot/grub2

# remove empty directories from USBISO dir
for dir in `ls $ISODIR/`
do
	if [ -z "`find $ISODIR/$dir -type f`" ]
	then
		echo "removing emtpy dir $ISODIR/$dir"
		rm -r $ISODIR/$dir
	fi
done

# copy iso(file|name) in place of ==isocopy==
for incfile in `ls $GLIMDIR/grub2/inc*\.cfg`
do
	# reset the variables
	file=""; name=""; copy=""

	while read -r line
	do
		if [[ "$line" == *isofile=* ]]
		then
			file="$line"

		elif [[ "$line" == *isoname=* ]]
		then
			name="$line"

		elif [[ "$line" == *isocopy=* ]]
		then
			# this is not really needed except to detect that isocopy exists
			copy="$line"
		fi

		# when all file, link, name and copy are found, copy into copy :)
		if [ "$file" != "" ] && [ "$name" != "" ] && [ "$copy" != "" ]
		then
			# build the filename for output
			outfile=`echo $incfile|sed s:"$GLIMDIR":"$USBDIR/boot/":`

			# sed the first occurrence!
			sed -i "0,/==isocopy/{s:==isocopy==:$name\n$file:}" $outfile

			# reset the variables
			file=""; name=""; copy=""
		fi

	done < <(grep -E 'iso(file|name|copy)=' $incfile | grep -v '#')
done

# make sure all changes are written to USB
sync

# ask if user wants to download more ISO's
read -p "Do you want to download ISO's? [y/N] " download
if [ "$download" == "y" ] || [ "$download" == "Y" ]
then
	if [ "$GLIMDIALOG" == "1" ]
	then
		# get screen width+height
		dh=`tput lines`
		dw=`tput cols`
		let dh=dh-5
		let dw=dw-10
		# setup basic Dialog-Command
		dialog_cmd=(dialog --keep-tite --backtitle "GRUB2 Live ISO Multiboot" --checklist "GRUB2 Live ISO Multiboot - Choose" $dh $dw $dh)
	fi

	# go through each inc-*.cfg file to look for iso-files to download
	for incfile in `ls $GLIMDIR/grub2/inc*\.cfg`
	do
		# if there is no isolink in $incfile don't even ask about downloading
		isolinktest=`grep -m1 isolink $incfile`
		if [ "$isolinktest" == "" ]
		then
			continue
		fi

		distro=$(echo $incfile|sed s/'.*inc-'/''/|sed s/'.cfg'/''/)

		if [ "$GLIMDIALOG" == "1" ]
		then
			active="off"
			# if there is an iso in the dir mark as active
			if [ -d $ISODIR/$distro/ ]
			then
				if [ "$(ls $ISODIR/$distro/|grep '\.iso')" != "" ]; then
					active="on"
				fi
				# OpenELEC does not have .iso file
				if [ "$(ls $ISODIR/$distro/|grep '\.tar')" != "" ]; then
					active="on"
				fi
			fi
			distros=("${distros[@]}" "$distro" "" "$active")
		else
			read -p "Do you want to download ISO's for '$distro'? [y/N] " distrod
			if [ "$distrod" != "y" ] && [ "$distrod" != "Y" ]
			then
				continue
			fi
			choices=("${choices[@]}" "$distro")
		fi

	done

	if [ "$GLIMDIALOG" == "1" ]; then
		choices=$("${dialog_cmd[@]}" "${distros[@]}" 2>&1 >/dev/tty)
	fi

	for choice in ${choices[@]}
	do
		incfile=$GLIMDIR/grub2/inc-$choice.cfg
		isos=()
		index=0
		index_wget=""

		# reset the variables
		file=""; link=""; name=""

		if [ "$GLIMDIALOG" == "0" ]
		then
			echo "| $choice"
		fi

		while read -r line
		do
			if [[ "$line" == *isofile=* ]]
			then
				file=`echo "$line"|cut -d'"' -f2`

			elif [[ "$line" == *isolink=* ]]
			then
				link=`echo "$line"|cut -d'"' -f2`

			elif [[ "$line" == *isoname=* ]]
			then
				name=`echo "$line"|cut -d'"' -f2`
			fi

			# when all file, link and name are found, initiate a download
			if [ "$file" != "" ] && [ "$link" != "" ] && [ "$name" != "" ]
			then
				# check if file is already in checked list
				if [ $(contains "${glim_list[@]}" "$file/$link/$name") != "y" ]
				then
					# add this file to checked list ( should it be $file, $link or $name ? )
					glim_list=("${glim_list[@]}" "$file/$link/$name")

					# replace the ${isoname} and ${isopath} grub-variables
					file=`echo "$file"|sed s/'${isoname}'/"$name"/g|sed s:'${isopath}':"$ISODIR":g`
					link=`echo "$link"|sed s/'${isoname}'/"$name"/g`

					# ToDo - check md5 checksum of downloaded file
					# - how to get the md5 checksum for an iso?
					# - maybe set isomd5="" in the grub .cfg files?
					# - this should also fix isos where the filename doesn't change when there is a new release...

					# check if this file has been downloaded...
					if [ "$GLIMDIALOG" == "1" ]
					then
						active="off"
						if [ -f $file ]
						then
							active="on"
						fi
						let "index++"
						index_wget[$index]="-O $file $link"
						isos=("${isos[@]}" "$index" "$name" "$active")
					else
						if [ -f $file ]
						then
							printf "> name: %-${maxl}s | OK\n" $name
						else
							printf "> name: %-${maxl}s " $name
							read -p "| Download ? [y/N] " download </dev/tty
							if [ "$download" == "y" ] || [ "$download" == "Y" ]
							then
								mkdir -p $(dirname $file)
								wget_links=("${wget_links[@]}" "-O $file $link")
							fi
						fi
					fi
				fi

				# reset the variables
				file=""; link=""; name=""
			fi

		done < <(grep -E 'iso(file|link|name)=' $incfile | grep -v '#')

		if [ "$GLIMDIALOG" == "1" ]
		then
			downloads=$("${dialog_cmd[@]}" "${isos[@]}" 2>&1 >/dev/tty)
			for download in $downloads
			do
				wget_links=("${wget_links[@]}" "${index_wget[$download]}")
			done
		fi

	done

	for wget_link in "${wget_links[@]}"
	do
		file=$(echo $wget_link|cut -d' ' -f2)
		link=$(echo $wget_link|cut -d' ' -f3)

		# check if already downloaded
		if [ -f $file ]
		then
			continue
		fi

		echo ""
		echo "$file"
		echo "wget $link"

		mkdir -p $(dirname $file)
		wget --quiet --show-progress $wget_link
	done

	# make sure all changes are written to USB
	sync
fi


# TinyCoreLinux needs the cde-dir from the iso to be in the usb-root
name=`grep 'isoname=' $GLIMDIR/grub2/inc-tinycorelinux.cfg | grep -v '#' | cut -d'"' -f2`
if [ -f $ISODIR/tinycorelinux/$name ] && [ ! -d $USBDIR/cde ]
then
	echo ""
	echo ">> Extracting files from $name"
	7z x -o$USBDIR $ISODIR/tinycorelinux/$name cde/ >/dev/null
fi

# OpenELEC needs KERNEL and SYSTEM in the usb-root
name=`grep 'isoname=' $GLIMDIR/grub2/inc-openelec.cfg | grep -v '#' | cut -d'"' -f2`
if [ -f $ISODIR/openelec/$name ] && [ ! -f $USBDIR/KERNEL ] && [ ! -f $USBDIR/SYSTEM ]
then
	echo ""
	echo ">> Extracting files from $name"
	tar -xf $ISODIR/openelec/$name --strip-components=2 -C $USBDIR $(echo "$name"|sed s/"\.tar"/""/)/target/KERNEL
	tar -xf $ISODIR/openelec/$name --strip-components=2 -C $USBDIR $(echo "$name"|sed s/"\.tar"/""/)/target/SYSTEM
fi


exit


# ToDo - unpacking etc.
if [ ! -f ./boot/iso/kolibri/kolibri.iso ]
then
# http://wiki.kolibrios.org/wiki/Booting_from_GRUB
	mkdir -p ./boot/iso/kolibri
	wget -O ./boot/iso/kolibri/latest-iso.7z http://builds.kolibrios.org/eng/latest-iso.7z
#	7z x latest-iso.7z
#	rm latest-iso.7z
fi

# ToDo - unpacking etc.
if [ ! -f ./boot/iso/haiku/haiku-r1alpha4.iso ]
then
	mkdir -p ./boot/iso/haiku
	wget -O ./boot/iso/haiku/haiku-r1alpha4.1-iso.zip http://ftp.snt.utwente.nl/pub/os/Haiku/releases/r1alpha4.1/haiku-r1alpha4.1-iso.zip
#	unzip haiku-r1alpha4.1-iso.zip
#	rm haiku-r1alpha4.1-iso.zip
fi

# ToDo - unpacking etc.
if [ ! -f ./boot/iso/menuetos/current.zip ]
then
	mkdir -p ./boot/iso/menuetos
	wget -O ./boot/iso/menuetos/current.zip http://www.menuetos.be/download.php?CurrentMenuetOS
fi

if [ ! -f ./boot/iso/webconverger/latest.iso ]
then
	mkdir -p ./boot/iso/webconverger
	wget -O ./boot/iso/webconverger/latest.iso http://dl.webconverger.com/latest.iso
fi

if [ ! -f ./boot/iso/sabayon/Sabayon_Linux_14.12_amd64_GNOME.iso ]
then
	mkdir -p ./boot/iso/sabayon
	wget -O ./boot/iso/sabayon/Sabayon_Linux_14.12_amd64_GNOME.iso http://dl.sabayon.org/iso/monthly/Sabayon_Linux_14.12_amd64_GNOME.iso
fi

if [ ! -f ./boot/iso/geexbox/geexbox-3.1-i386.iso ]
then
	mkdir -p ./boot/iso/geexbox
	wget -O ./boot/iso/geexbox/geexbox-3.1-i386.iso http://www.geexbox.org/wp-content/plugins/download-monitor/download.php?id=geexbox-3.1-i386.iso
fi

if [ ! -f ./boot/iso/rlsd/rlsd-12112014-i686.iso ]
then
	mkdir -p ./boot/iso/rlsd
	wget -O ./boot/iso/rlsd/rlsd-12112014-i686.iso http://dimkr.insomnia247.nl/releases/i686/rlsd-12112014-i686.iso
fi

if [ ! -f ./boot/iso/delicate/delicate-0.1-alpha5.iso ]
then
	mkdir -p ./boot/iso/delicate
	wget -O ./boot/iso/delicate/delicate-0.1-alpha5.iso http://delicate-linux.net/0.1/download/iso/delicate-0.1-alpha5.iso
fi
