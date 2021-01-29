host_bits=$(getconf LONG_BIT)

# -------------------------------------
# Menu
# -------------------------------------

function checkifinstalled {
	if [ -f /emuroot/arm-linux-gnueabi/var/lib/dpkg/status ]; then
    	emurootfs_exists_arm_linux_gnueabi=1
	else 
    	emurootfs_exists_arm_linux_gnueabi=0
	fi

	if [ -f /emuroot/arm-linux-gnueabihf/var/lib/dpkg/status ]; then
	    emurootfs_exists_arm_linux_gnueabihf=1
	else 
    	emurootfs_exists_arm_linux_gnueabihf=0
	fi

	if [ -f /emuroot/aarch64-linux-gnu/var/lib/dpkg/status ]; then
    	emurootfs_exists_aarch64_linux_gnu=1
	else 
	    emurootfs_exists_aarch64_linux_gnu=0
	fi

	if [ -f /emuroot/i386-linux-gnu/var/lib/dpkg/status ]; then
    emurootfs_exists_i386_linux_gnu=1
	else 
	    emurootfs_exists_i386_linux_gnu=0
	fi

	if [ -f /emuroot/x86_64-linux-gnu/var/lib/dpkg/status ]; then
	    emurootfs_exists_x86_64_linux_gnu=1
	else 
	    emurootfs_exists_x86_64_linux_gnu=0
	fi

	if [ -f /emuroot/mips-linux-gnu/var/lib/dpkg/status ]; then
	    emurootfs_exists_mips_linux_gnu=1
	else 
	    emurootfs_exists_mips_linux_gnu=0
	fi

	if [ -f /emuroot/mips64el-linux-gnuabi64/var/lib/dpkg/status ]; then
	    emurootfs_exists_mips64el_linux_gnuabi64=1
	else 
	    emurootfs_exists_mips64el_linux_gnuabi64=0
	fi
	
	if [ -f /emuroot/mipsel-linux-gnu/var/lib/dpkg/status ]; then
    	emurootfs_exists_mipsel_linux_gnu=1
	else 
	    emurootfs_exists_mipsel_linux_gnu=0
	fi
	
	if [ -f /emuroot/powerpc-linux-gnu/var/db/xbps/pkgdb-0.38.plist ]; then
 		emurootfs_exists_powerpc_linux_gnu=1
	else 
 		emurootfs_exists_powerpc_linux_gnu=0
	fi
	
	if [ -f /emuroot/powerpc64-linux-gnu/var/db/xbps/pkgdb-0.38.plist ]; then
 		emurootfs_exists_powerpc64_linux_gnu=1
	else 
 		emurootfs_exists_powerpc64_linux_gnu=0
	fi

	if [ -f /emuroot/powerpc64le-linux-gnu/var/lib/dpkg/status ]; then
 		emurootfs_exists_powerpc64le_linux_gnu=1
	else 
 		emurootfs_exists_powerpc64le_linux_gnu=0
	fi
	
	if [ -f /emuroot/s390x-linux-gnu/var/lib/dpkg/status ]; then
	    emurootfs_exists_s390x_linux_gnu=1
	else 
	    emurootfs_exists_s390x_linux_gnu=0
	fi
}

function existingstatetoreadable {
	if [ $1 = 1 ]; then
	    echo Installed
	else 
	    echo NotInstalled
	fi
}

function archmenu32 {
	SelectedArch=$(whiptail --menu "Select Arch" 20 70 10 "linux-armel" $(existingstatetoreadable $emurootfs_exists_arm_linux_gnueabi) "linux-armhf" $(existingstatetoreadable $emurootfs_exists_arm_linux_gnueabihf) "linux-i386" $(existingstatetoreadable $emurootfs_exists_i386_linux_gnu) "linux-mips" $(existingstatetoreadable $emurootfs_exists_mips_linux_gnu) "linux-mipsel" $(existingstatetoreadable $emurootfs_exists_mipsel_linux_gnu) "linux-powerpc" $(existingstatetoreadable $emurootfs_exists_powerpc_linux_gnu) "linux-s390x" $(existingstatetoreadable $emurootfs_exists_s390x_linux_gnu) 3>&1 1>&2 2>&3)
	selectedarchoptions
}

function archmenu64 {
	SelectedArch=$(whiptail --menu "Select Arch" 20 70 10 "linux-armel" $(existingstatetoreadable $emurootfs_exists_arm_linux_gnueabi) "linux-armhf" $(existingstatetoreadable $emurootfs_exists_arm_linux_gnueabihf) "linux-arm64" "$(existingstatetoreadable $emurootfs_exists_aarch64_linux_gnu)" "linux-i386" $(existingstatetoreadable $emurootfs_exists_i386_linux_gnu) "linux-x86_64" $(existingstatetoreadable $emurootfs_exists_x86_64_linux_gnu) "linux-mips" $(existingstatetoreadable $emurootfs_exists_mips_linux_gnu) "linux-mipsel" $(existingstatetoreadable $emurootfs_exists_mipsel_linux_gnu) "linux-mips64el" $(existingstatetoreadable $emurootfs_exists_mips64el_linux_gnuabi64) "linux-powerpc" $(existingstatetoreadable $emurootfs_exists_powerpc_linux_gnu) "linux-powerpc64" $(existingstatetoreadable $emurootfs_exists_powerpc64_linux_gnu) "linux-powerpc64le" $(existingstatetoreadable $emurootfs_exists_powerpc64le_linux_gnu) "linux-s390x" $(existingstatetoreadable $emurootfs_exists_s390x_linux_gnu) 3>&1 1>&2 2>&3)
	selectedarchoptions
}


function selectedarchoptions {
	if [ -z "$SelectedArch" ]
	then
    	exit
	else
    	optionselect
	fi
}


function startarchmenu {
	if [ $host_bits = 64 ]; then
		archmenu64
	else 
		archmenu32
	fi
}

function optionselect {
	SelectionOption=$(whiptail --menu "Confirm?" 20 60 10 \
 	    "Yes" "Install RootFS" \
 	    "No" "Start Bash Shell" \
 	    3>&1 1>&2 2>&3)
	if [ -z "$SelectionOption" ]
	then
    	checkifinstalled
		startarchmenu
	else
		if [[ $SelectionOption == "Yes" ]]; then
			emuroot-install
		fi
    	checkifinstalled
		startarchmenu
	fi
}

# -------------------------------------
# emuroot
# -------------------------------------

debian-install () {
	mkdir /emuroot/
	mkdir $DebianEmuRootInstaller_RootPath
	cd $DebianEmuRootInstaller_RootPath
	qemu-debootstrap --arch=$DebianEmuRootInstaller_CPU buster $DebianEmuRootInstaller_RootPath http://ftp.debian.org/debian
	DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true LC_ALL=C LANGUAGE=C LANG=C chroot $DebianEmuRootInstaller_RootPath /debootstrap/debootstrap --second-stage

	rm $DebianEmuRootInstaller_RootPath/etc/apt/sources.list
	echo 'deb http://deb.debian.org/debian buster main contrib non-free' >> $DebianEmuRootInstaller_RootPath/etc/apt/sources.list
	echo 'deb-src http://deb.debian.org/debian buster main contrib non-free' >> $DebianEmuRootInstaller_RootPath/etc/apt/sources.list
	echo 'deb http://deb.debian.org/debian-security/ buster/updates main contrib non-free' >> $DebianEmuRootInstaller_RootPath/etc/apt/sources.list
	echo 'deb-src http://deb.debian.org/debian-security/ buster/updates main contrib non-free' >> $DebianEmuRootInstaller_RootPath/etc/apt/sources.list
	echo 'deb http://deb.debian.org/debian buster-updates main contrib non-free' >> $DebianEmuRootInstaller_RootPath/etc/apt/sources.list
	echo 'deb-src http://deb.debian.org/debian buster-updates main contrib non-free' >> $DebianEmuRootInstaller_RootPath/etc/apt/sources.list
	echo 'deb http://deb.debian.org/debian buster-backports main contrib non-free' >> $DebianEmuRootInstaller_RootPath/etc/apt/sources.list
	echo 'deb-src http://deb.debian.org/debian buster-backports main contrib non-free' >> $DebianEmuRootInstaller_RootPath/etc/apt/sources.list

	env -i TERM=xterm /usr/sbin/chroot $DebianEmuRootInstaller_RootPath /bin/su -l root -c 'apt-get update'
	env -i TERM=xterm /usr/sbin/chroot $DebianEmuRootInstaller_RootPath /bin/su -l root -c 'apt-get install -y libsm6 libxext6 libfreetype6 libmpg123-0 sudo'
}

emuroot-install () {
	if [[ $SelectedArch == "linux-arm64" ]]; then
		DebianEmuRootInstaller_RootPath="/emuroot/aarch64-linux-gnu"
		DebianEmuRootInstaller_CPU=arm64
		debian-install
	fi
	if [[ $SelectedArch == "linux-armel" ]]; then
		DebianEmuRootInstaller_RootPath="/emuroot/arm-linux-gnueabi"
		DebianEmuRootInstaller_CPU=armel
		debian-install
	fi
	if [[ $SelectedArch == "linux-armhf" ]]; then
		DebianEmuRootInstaller_RootPath="/emuroot/arm-linux-gnueabihf"
		DebianEmuRootInstaller_CPU=armhf
		debian-install
	fi
	if [[ $SelectedArch == "linux-i386" ]]; then
		DebianEmuRootInstaller_RootPath="/emuroot/i386-linux-gnu"
		DebianEmuRootInstaller_CPU=i386
		debian-install
	fi
	if [[ $SelectedArch == "linux-mips" ]]; then
		DebianEmuRootInstaller_RootPath="/emuroot/mips-linux-gnu"
		DebianEmuRootInstaller_CPU=mips
		debian-install
	fi
	if [[ $SelectedArch == "linux-mips64el" ]]; then
		DebianEmuRootInstaller_RootPath="/emuroot/mips64el-linux-gnuabi64"
		DebianEmuRootInstaller_CPU=mips64el
		debian-install
	fi
	if [[ $SelectedArch == "linux-mipsel" ]]; then
		DebianEmuRootInstaller_RootPath="/emuroot/mipsel-linux-gnu"
		DebianEmuRootInstaller_CPU=mipsel
		debian-install
	fi
	if [[ $SelectedArch == "linux-powerpc" ]]; then
		mkdir /emuroot/powerpc-linux-gnu/
		wget https://repo.voidlinux-ppc.org/live/current/void-ppc-ROOTFS-20200411.tar.xz -O /tmp/voidrootfs.tar.xz
		tar -xf /tmp/voidrootfs.tar.xz -C /emuroot/powerpc-linux-gnu/
		rm /tmp/voidrootfs.tar.xz
	fi
	if [[ $SelectedArch == "linux-powerpc" ]]; then
		mkdir /emuroot/powerpc-linux-gnu/
		wget https://repo.voidlinux-ppc.org/live/current/void-ppc-ROOTFS-20200411.tar.xz -O /tmp/voidrootfs.tar.xz
		tar -xf /tmp/voidrootfs.tar.xz -C /emuroot/powerpc-linux-gnu/
		rm /tmp/voidrootfs.tar.xz
	fi
	if [[ $SelectedArch == "linux-powerpc64" ]]; then
		mkdir /emuroot/powerpc64-linux-gnu/
		wget https://repo.voidlinux-ppc.org/live/current/void-ppc64-ROOTFS-20200411.tar.xz -O /tmp/voidrootfs.tar.xz
		tar -xf /tmp/voidrootfs.tar.xz -C /emuroot/powerpc64-linux-gnu/
		rm /tmp/voidrootfs.tar.xz
	fi
	if [[ $SelectedArch == "linux-powerpc64le" ]]; then
		DebianEmuRootInstaller_RootPath="/emuroot/powerpc64le-linux-gnu"
		DebianEmuRootInstaller_CPU=ppc64el
		debian-install
	fi
	if [[ $SelectedArch == "linux-s390x" ]]; then
		DebianEmuRootInstaller_RootPath="/emuroot/s390x-linux-gnu"
		DebianEmuRootInstaller_CPU=s390x
		debian-install
	fi
	if [[ $SelectedArch == "linux-x86_64" ]]; then
		DebianEmuRootInstaller_RootPath="/emuroot/x86_64-linux-gnu"
		DebianEmuRootInstaller_CPU=amd64
		debian-install
	fi
}

checkifinstalled
startarchmenu
