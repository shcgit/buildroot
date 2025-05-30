#!/bin/bash

set -euo pipefail

if [[ -z "${TARGET_DIR:-}" ]]; then
	echo "ERROR: TARGET_DIR environment variable not set" >&2
	exit 1
fi

if [[ -z "${HOST_DIR:-}" ]]; then
	echo "ERROR: HOST_DIR environment variable not set" >&2
	exit 1
fi

declare -a remove_items=(
	bin/asc2log
	bin/bcmserver
	bin/can-calc-bit-timing
	bin/canbusload
	bin/canfdtest
	bin/cangen
	bin/cangw
	bin/canlogserver
	bin/canplayer
	bin/cansequence
	bin/cansniffer
	bin/chattr
	bin/compile_et
	bin/drmdevice
	bin/gpiodetect
	bin/gpiomon
	bin/gpionotify
	bin/isotp*
	bin/j1939*
	bin/lowntfs-3g
	bin/log2asc
	bin/log2long
	bin/lsattr
	bin/mcp251xfd-dump
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
	bin/slcanpty
	bin/slcan_attach
	bin/slcand
	bin/testj1939
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
for pattern in "${remove_items[@]}"; do
	for item in $TARGET_DIR/$pattern; do
		if [[ -f "$item" ]]; then
			rm -f "$item"
		fi
		if [[ -L "$item" ]]; then
			rm -f "$item"
		fi
		if [[ -d "$item" ]]; then
			rm -fR "$item"
		fi
	done
done

strip_files() {
	local dir="$1"

	if [[ ! -d "$dir" ]]; then
		return
	fi

	find "$dir" -type f \( -executable -o -name "*.so*" \) ! -name "*.ko" -print0 | \
	xargs -0 -r "$HOST_DIR/bin/arm-linux-strip" \
		--strip-debug \
		--strip-unneeded \
		-R .comment \
		-R .note \
		-R .note.gnu.build-id
}

script_path="$0"
resolved_script_path=$(realpath "$script_path")
BOARD_DIR=$(dirname "$resolved_script_path")
MILAS_ROOT=$(realpath "$BOARD_DIR/../../../..")

# Install Milas-specific files
if [[ -f "$MILAS_ROOT/apps/informer/informer" ]]; then
	echo "Installing Milas components..."
	install -D -m 0755 "$MILAS_ROOT/apps/informer/informer" "$TARGET_DIR/bin/informer"

	# Install KMS files
	mkdir -p "$TARGET_DIR/usr/share/kms"
	cp -f "$MILAS_ROOT"/misc/kms/* "$TARGET_DIR/usr/share/kms"

	# Install sound files
	mkdir -p "$TARGET_DIR/usr/share/sounds"
	cp -f "$MILAS_ROOT"/misc/sounds/new/*.pcm "$TARGET_DIR/usr/share/sounds"
fi

strip_files "$TARGET_DIR/bin"
strip_files "$TARGET_DIR/sbin"
strip_files "$TARGET_DIR/lib"
strip_files "$TARGET_DIR/lib/dri"
strip_files "$TARGET_DIR/lib/gstreamer-1.0"

if [[ -d "$TARGET_DIR/lib/qt/plugins" ]]; then
	while IFS= read -r -d $'\0' plugin_dir; do
		strip_files "$plugin_dir"
	done < <(find "$TARGET_DIR/lib/qt/plugins" -mindepth 1 -maxdepth 1 -type d -print0)
fi

exit 0
