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

strip_all()
{
	$HOST_DIR/bin/arm-linux-strip \
	"--strip-debug --strip-unneeded -R .comment -R .note -R .note.gnu.build-id" \
	$TARGET_DIR/$1/* 2>/dev/null
}

BOARD_DIR="$(dirname $0)"
MILAS_ROOT="$BOARD_DIR/../../../.."

# Install Milas-specific files
if [ -f $MILAS_ROOT/apps/informer/informer ]; then
	cp -f $MILAS_ROOT/apps/informer/informer $TARGET_DIR/bin

	mkdir -p $TARGET_DIR/usr/share/kms
	cp -f $MILAS_ROOT/misc/kms/* $TARGET_DIR/usr/share/kms

	mkdir -p $TARGET_DIR/usr/share/sounds
	cp -f $MILAS_ROOT/misc/sounds/new/*.pcm $TARGET_DIR/usr/share/sounds
fi

strip_all bin
strip_all sbin
strip_all lib
strip_all lib/dri
strip_all lib/gstreamer-1.0

for d in `ls $TARGET_DIR/lib/qt/plugins`; do
	strip_all lib/qt/plugins/$d/*
done

exit 0
