#!/bin/bash
mkdir -p /opt/challenge
echo "Find the flag in a running process." > /opt/challenge/START_HERE
# Start a background process that sleeps forever and carries the flag in its command line
(exec -a "secret-agent-flag{process_secret_id}" sleep 99999) &
chmod -R 755 /opt/challenge
