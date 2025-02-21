#! /bin/bash

case "$1" in
start)
	echo "Initializing sound..."

	for snddev in /dev/snd/controlC*; do
		[ -e "$snddev" ] || continue

		sndname=`basename $snddev`
		sndidx=${sndname#controlC}

		/sbin/alsactl -I -i /share/init/00main -f /etc/alsa.state restore $sndidx
	done

	;;
esac

exit 0
