#!/bin/bash
set -e

trap "apachectl -k graceful-stop" TERM INT

# This sleep seems to be required for certain Docker/OS combos as the bind mounts may not be fully ready
#sleep 10

rm -rf /opt/rh/httpd24/root/var/run/httpd/*

# Launch Apache as a child-process of this script so we can 'wait' on it
httpd -D FOREGROUND &

# Wait for the Apache pid file to be populated
until [ -e '/opt/rh/httpd24/root/var/run/httpd/httpd.pid' ]; do
  sleep 5
  echo "Waiting for Drupal PID file at '/opt/rh/httpd24/root/var/run/httpd/httpd.pid'"
done

# Read the pid that Apache is running as
PID=$(cat /opt/rh/httpd24/root/var/run/httpd/httpd.pid)
echo "Success: Drupal is running as PID '$PID'"

# We now wait for as long as Apache is running
wait $PID

# We've been sent an interrupt, remove our traps and make sure we wait for Apache to fully close
trap - TERM INT
wait $PID

# Exit with the status code of the Apache process
exit $?