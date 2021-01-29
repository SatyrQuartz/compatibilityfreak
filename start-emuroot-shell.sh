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
	setup-vars-for-emuroot-shell
}

# -------------------------------------
# emuroot
# -------------------------------------

start-emuroot-shell () {
	if [ -f /usr/bin/groot ]; then
		cd $StartEmuRootShell_RootPath
    	groot
	else 
    	chroot $StartEmuRootShell_RootPath
	fi
}

setup-vars-for-emuroot-shell () {
	if [[ $SelectedArch == "linux-arm64" ]]; then
		StartEmuRootShell_RootPath="/emuroot/aarch64-linux-gnu"
		start-emuroot-shell
	fi
	if [[ $SelectedArch == "linux-armel" ]]; then
		StartEmuRootShell_RootPath="/emuroot/arm-linux-gnueabi"
		start-emuroot-shell
	fi
	if [[ $SelectedArch == "linux-armhf" ]]; then
		StartEmuRootShell_RootPath="/emuroot/arm-linux-gnueabihf"
		start-emuroot-shell
	fi
	if [[ $SelectedArch == "linux-i386" ]]; then
		StartEmuRootShell_RootPath="/emuroot/i386-linux-gnu"
		start-emuroot-shell
	fi
	if [[ $SelectedArch == "linux-mips" ]]; then
		StartEmuRootShell_RootPath="/emuroot/mips-linux-gnu"
		start-emuroot-shell
	fi
	if [[ $SelectedArch == "linux-mips64el" ]]; then
		StartEmuRootShell_RootPath="/emuroot/mips64el-linux-gnuabi64"
		start-emuroot-shell
	fi
	if [[ $SelectedArch == "linux-mipsel" ]]; then
		StartEmuRootShell_RootPath="/emuroot/mipsel-linux-gnu"
		start-emuroot-shell
	fi
	if [[ $SelectedArch == "linux-powerpc" ]]; then
		StartEmuRootShell_RootPath="/emuroot/powerpc-linux-gnu/"
		start-emuroot-shell
	fi
	if [[ $SelectedArch == "linux-powerpc64" ]]; then
		StartEmuRootShell_RootPath="/emuroot/powerpc64-linux-gnu/"
		start-emuroot-shell
	fi
	if [[ $SelectedArch == "linux-powerpc64le" ]]; then
		StartEmuRootShell_RootPath="/emuroot/powerpc64le-linux-gnu"
		start-emuroot-shell
	fi
	if [[ $SelectedArch == "linux-s390x" ]]; then
		StartEmuRootShell_RootPath="/emuroot/s390x-linux-gnu"
		start-emuroot-shell
	fi
	if [[ $SelectedArch == "linux-x86_64" ]]; then
		StartEmuRootShell_RootPath="/emuroot/x86_64-linux-gnu"
		start-emuroot-shell
	fi
}

checkifinstalled
startarchmenu
