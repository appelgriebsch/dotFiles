#!/usr/bin/env bash

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

MON=$(polybar --list-monitors | wc -l)

# Launch main bar
polybar main &
if [ $MON -gt 1 ]; then
  polybar second &
fi

echo "Polybar launched..."
