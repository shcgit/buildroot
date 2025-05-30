#! /bin/bash

if ! grep -Eq '\bfeature-hostapp\b' /proc/cmdline; then
	exit 0
fi

APP=$(/bin/hostapp)
PID="/var/lock/$APP.pid"

if [ ! -f "/bin/$APP" ]; then
	echo "Application /bin/$APP not found!" >&2
	exit 0
fi

case "$1" in
start)
	echo "Starting host application ($APP)..."

	if [ -f "$PID" ]; then
		pid=$(cat "$PID")
		if kill -0 "$pid" 2>/dev/null; then
			echo "Application is already running with PID $pid" >&2
			exit 1
		fi
	fi

	(
		. /etc/profile

		/bin/"$APP"

		status=$?
		if [ $status -ne 0 ]; then
			echo "Application crashed with status $status, rebooting..." >&2
			exec /sbin/reboot -f
		fi
	) &

	;;

stop)
	echo "Stopping host application..."

	if [ ! -f "$PID" ]; then
		exit 1
	fi

	pid=$(cat "$PID")
	if ! kill -0 "$pid" 2>/dev/null; then
		echo "Process $pid not running, removing stale PID file" >&2
		rm -f "$PID"
		exit 1
	fi

	kill -TERM "$pid" 2>/dev/null

	timeout=5
	while kill -0 "$pid" 2>/dev/null && [ $timeout -gt 0 ]; do
		sleep 1
		timeout=$((timeout - 1))
	done

	if kill -0 "$pid" 2>/dev/null; then
		echo "Force killing process $pid" >&2
		kill -KILL "$pid"
	fi

	rm -f "$PID"

	;;
esac

exit 0
