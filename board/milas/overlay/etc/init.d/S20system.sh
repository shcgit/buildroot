#! /bin/bash

case "$1" in
start)
	echo "Setup system..."

	TZ=UTC
	export TZ

	[ -e /dev/rtc1 ] && /sbin/hwclock -f /dev/rtc1 -s 2>/dev/null

	for i in cache lib lock log run spool tmp ; do
		mkdir /var/$i
	done
	for i in nobody avahi-autoipd ; do
		mkdir /tmp/$i
	done

	touch /var/run/utmp
	touch /var/log/wtmp

	UNAME=`/bin/uname -sr`
	echo -n "Linux $UNAME" > /var/issue

	echo "domain localdomain" > /var/resolv.conf
	echo "search localdomain" >> /var/resolv.conf

	touch /var/udhcpd.leases

	;;
esac

exit 0
