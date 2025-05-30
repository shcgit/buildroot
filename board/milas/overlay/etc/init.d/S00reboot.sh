#!/bin/bash

case "$1" in
stop)
	sync

	if [ -c /dev/watchdog ]; then
		printf 'V' > /dev/watchdog 2>/dev/null
		printf '\0' > /dev/watchdog 2>/dev/null
	fi

	;;
esac

exit 0
