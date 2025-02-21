#!/bin/bash

case "$1" in
stop)
	sync
	echo -n 0 > /dev/watchdog 2>/dev/null

	;;
esac

exit 0
