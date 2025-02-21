#! /bin/bash

if ! grep -Eq '\bfeature-hostapp\b' /proc/cmdline; then
	exit 0;
fi

APP=`/bin/hostapp`
PID=/var/lock/$APP.pid

[ ! -f /bin/$APP ] && exit 0

case "$1" in
start)
	echo "Starting host application ($APP)..."

	. /etc/profile
	/bin/$APP || /sbin/reboot &

	;;

stop)
	echo "Stopping host application..."

	[ -f $PID ] && kill -SIGTERM `cat $PID` 2>/dev/null

	;;
esac

exit 0
