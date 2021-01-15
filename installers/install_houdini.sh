
function patch_strings_in_file() {
	local FILE="$1"
	local PATTERN="$2"
	local REPLACEMENT="$3"

	# Find all unique strings in FILE that contain the pattern 
	STRINGS=$(strings ${FILE} | grep ${PATTERN} | sort -u -r)

	if [ "${STRINGS}" != "" ] ; then

		for OLD_STRING in ${STRINGS} ; do
			# Create the new string with a simple bash-replacement
			NEW_STRING=${OLD_STRING//${PATTERN}/${REPLACEMENT}}

			# Create null terminated ASCII HEX representations of the strings
			OLD_STRING_HEX="$(echo -n ${OLD_STRING} | xxd -g 0 -u -ps -c 256)00"
			NEW_STRING_HEX="$(echo -n ${NEW_STRING} | xxd -g 0 -u -ps -c 256)00"

			if [ ${#NEW_STRING_HEX} -le ${#OLD_STRING_HEX} ] ; then
				# Pad the replacement string with null terminations so the
				# length matches the original string
				while [ ${#NEW_STRING_HEX} -lt ${#OLD_STRING_HEX} ] ; do
					NEW_STRING_HEX="${NEW_STRING_HEX}00"
				done

				# Now, replace every occurrence of OLD_STRING with NEW_STRING 
				echo -n "Replacing ${OLD_STRING} with ${NEW_STRING}... "
				hexdump -ve '1/1 "%.2X"' ${FILE} | \
				sed "s/${OLD_STRING_HEX}/${NEW_STRING_HEX}/g" | \
				xxd -r -p > ${FILE}.tmp
				chmod --reference ${FILE} ${FILE}.tmp
				mv ${FILE}.tmp ${FILE}
				echo "Done!"
			else
				echo "New string '${NEW_STRING}' is longer than old" \
					 "string '${OLD_STRING}'. Skipping."
			fi
		done
	fi
}

if [ -f /emuroot/arm-linux-gnueabihf/usr/lib/arm-linux-gnueabihf/ld-linux-armhf.so.3 ]; then
    mkdir arm64_x64
    mkdir armv7_x64
    
    wget http://dl.android-x86.org/houdini/6_z/houdini.sfs -O houdini-6_z.sfs
    unsquashfs houdini-6_z.sfs
    cp squashfs-root/houdini64 arm64_x64/
    cp squashfs-root/cpuinfo arm64_x64/
    cp squashfs-root/linker64 arm64_x64/
    rm -rf squashfs-root
    
    wget http://dl.android-x86.org/houdini/6_y/houdini.sfs -O houdini-6_y.sfs
    unsquashfs houdini-6_y.sfs
    cp squashfs-root/houdini armv7_x64/
    cp squashfs-root/cpuinfo armv7_x64/
    cp squashfs-root/linker armv7_x64/
    rm -rf squashfs-root
    
    patch_strings_in_file arm64_x64/houdini64 "/system/lib64/arm64/cpuinfo" "/usr/lib/houdini/cpu64"
    patch_strings_in_file arm64_x64/houdini64 "/system/lib64/arm64/linker64" "/usr/lib/houdini/ld64.so"
    patch_strings_in_file arm64_x64/houdini64 "/system/lib64/arm64/libaeabi_map.so" ""
    
    patch_strings_in_file armv7_x64/houdini "/system/lib/arm/cpuinfo" "/usr/lib/houdini/cpu32"
    patch_strings_in_file armv7_x64/houdini "/system/lib/arm/linker" "/usr/lib/houdini/ld.so"
    patch_strings_in_file armv7_x64/houdini "/system/lib/arm/libaeabi_map.so" ""

    mkdir -p /usr/libexec
    install -m 755 arm64_x64/houdini64 /usr/libexec/houdini64
    install -m 755 armv7_x64/houdini /usr/libexec/houdini
    
    mkdir -p /usr/lib/houdini
    install -m 644 arm64_x64/cpuinfo /usr/lib/houdini/cpu64
    install -m 644 armv7_x64/cpuinfo /usr/lib/houdini/cpu32
    ln -s /emuroot/arm-linux-gnueabihf/lib/ld-linux-armhf.so.3 /usr/lib/houdini/ld.so  
    ln -s /emuroot/aarch64-linux-gnu/lib/ld-linux-aarch64.so.1 /usr/lib/houdini/ld64.so
    
    rm -rf armv7_x64
    rm -rf arm64_x64
    rm houdini-6_y.sfs
    rm houdini-6_z.sfs

    update-binfmts --install houdini /usr/libexec/houdini --magic "\x7f\x45\x4c\x46\x01\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x28\x00" --mask "\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff"
else 
    echo please install armhf and arm64 emuroot first
fi
