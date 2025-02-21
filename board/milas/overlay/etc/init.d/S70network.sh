#! /bin/bash

case "$1" in
start)
	echo "Starting network..."

	if [ -d /sys/class/net/lo ]; then
		/sbin/ifconfig lo 127.0.0.1 netmask 255.0.0.0 up
		/sbin/route add -net 127.0.0.0/8 gw 127.0.0.1 dev lo
	fi

	for intfp in /sys/class/net/eth* ; do
		[ -e "$intfp" ] || continue

		intfn=`basename $intfp`

		/sbin/ifconfig $intfn up

		/sbin/avahi-autoipd --no-drop-root --force-bind -D $intfn
		/sbin/udhcpc -i $intfn:dhcpc -p /var/run/udhcpc.$intfn.pid -a -B -b &
	done

	;;

stop)
	echo "Stopping network..."

	for intfp in /sys/class/net/eth* ; do
		intfn=`basename $intfp`

		if [ -f /var/run/udhcpc.$intfn.pid ]; then
			kill `cat /var/run/udhcpc.$intfn.pid` 2>/dev/null
			usleep 100
			/sbin/ifconfig $intfn:dhcpc down

			interface=$intfn:dhcpc /etc/network/default.script deconfig
		fi

		/sbin/avahi-autoipd -k $intfn

		/sbin/ifconfig $intfn down
	done

	if [ -d /sys/class/net/lo ]; then
		/sbin/route del -net 127.0.0.0/8 dev lo
		/sbin/ifconfig lo down
	fi

	;;
esac

exit 0
