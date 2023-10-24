#!/bin/sh

PID_FILE="/var/run/dnsproxy.pid"

echo $$ >"${PID_FILE}"
echo "Shell PID: $$"

# Use shell as parent process and put dnsproxy to the background.
/opt/adguard-dnsproxy/dnsproxy \
  --config-path=/opt/adguard-dnsproxy/config.yaml \
  --output=/var/log/dnsproxy.log &

graceful_exit() {
  signal=$1
  echo "$(date): Receive ${signal}. Start graceful exit."
  kill -TERM "${child_pid}"
  echo "$(date): Clean up macOS DNS cache."
  dscacheutil -flushcache
  killall -HUP mDNSResponder
  exit 0
}

# These will execute the exit function when the process gets a signal.
trap 'graceful_exit TERM' TERM
trap 'graceful_exit INT' INT
trap 'graceful_exit HUP' HUP

echo "$(date): Started tasks - press Ctrl-C to stop them."
child_pid=$!
echo "$(date): dnsproxy PID: ${child_pid} runing."

# Waiting for dnsproxy termination.
wait "${child_pid}"
