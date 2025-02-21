#! /bin/bash

URANDOM=/dev/urandom

case "$1" in
start)
	echo "Initializing random number generator..."
	cat /proc/cpuinfo > $URANDOM
	date > $URANDOM

	;;
esac

exit 0
