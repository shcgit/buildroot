#!/bin/bash

[ ! -f /sbin/udevd ] && exit 0

case "$1" in
start)
	echo "Starting eudev..."
	[ -e /proc/sys/kernel/hotplug ] && printf '\000\000\000\000' > /proc/sys/kernel/hotplug
	rm -f /dev/kmsg
	/sbin/udevd -d 2>/dev/null || { echo "FAIL"; exit 1; }
	udevadm trigger --type=subsystems --action=add
	udevadm trigger --type=devices --action=add
	udevadm settle --timeout=30 || echo "udevadm settle failed"

	;;
stop)
	udevadm control --stop-exec-queue
	killall udevd

	;;
esac

exit 0
