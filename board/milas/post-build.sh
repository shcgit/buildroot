#!/bin/bash

list_rm=(
	bin/chattr
	bin/compile_et
	bin/drmdevice
	bin/lowntfs-3g
	bin/lsattr
	bin/mk_cmds
	bin/modeprint
	bin/ntfs-3g.probe
	bin/ntfscat
	bin/ntfscluster
	bin/ntfscmp
	bin/ntfsinfo
	bin/ntfsls
	bin/pcre2grep
	bin/pcre2test
	bin/proptest
	bin/vbltest
	sbin/badblocks
	sbin/dump.exfat
	sbin/dumpe2fs
	sbin/e2freefrag
	sbin/e2label
	sbin/e2mmpstatus
	sbin/e2undo
	sbin/e4crypt
	sbin/exfat2img
	sbin/exfatlabel
	sbin/filefrag
	sbin/logsave
	sbin/mklost+found
	sbin/mount.lowntfs-3g
	sbin/mount.ntfs-3g
	sbin/ntfsclone
	sbin/ntfscp
	sbin/ntfslabel
	sbin/ntfsresize
	sbin/ntfsundelete
	sbin/tune.exfat
	sbin/tune2fs
	lib/avahi
	lib/dri/swrast_dri.so
	lib/metatypes
	lib/ntfs-3g
	lib/libQt5Test.*
	lib/libstdc++.so.6.0.33-gdb.py
	lib/os-release
	share/alsa/cards
	share/alsa/ctl
	share/alsa/init
	share/alsa/pcm
	share/alsa/speaker-test
	share/drirc.d
	share/et
	share/sounds/alsa
	share/ss
	share/udhcpc
	etc/init.d/S05avahi-setup.sh
	etc/init.d/S10udev
	etc/os-release
	dev/shm/lib
)

# Remove unused entries
for i in "${list_rm[@]}"; do
	# Expand wildcards
	for f in $TARGET_DIR/$i; do
		# Files
		[ -f $f ] && rm -f $f
		# Symlinks
		[ -L $f ] && rm -f $f
		# Directories
		[ -d $f ] && rm -fR $f
	done
done

exit 0
