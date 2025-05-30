#! /bin/bash

case "$1" in
start)
	echo "Setup system..."

	export TZ=UTC

	[ -e /dev/rtc1 ] && /sbin/hwclock -f /dev/rtc1 -s 2>/dev/null

	for i in cache lib lock log run spool tmp ; do
		mkdir /var/$i
	done
	for i in nobody avahi-autoipd ; do
		mkdir /tmp/$i
	done

	touch /var/run/utmp /var/log/wtmp /var/udhcpd.leases

	uname_info=$(uname -sr)
	printf "Linux %s\n" "$uname_info" > /var/issue

	printf "domain localdomain\n" >> /etc/resolv.conf
	printf "search localdomain\n" >> /etc/resolv.conf
	printf "nameserver 127.0.0.1\n" >> /etc/resolv.conf

	;;
esac

exit 0
