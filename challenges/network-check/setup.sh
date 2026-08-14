#!/bin/bash
mkdir -p /opt/challenge /tmp/web
echo "flag{local_port_handshake}" > /tmp/web/index.html
echo "Interact with localhost on port 8080." > /opt/challenge/START_HERE
# Start python HTTP server on 8080 in background
cd /tmp/web && (python3 -m http.server 8080 --bind 127.0.0.1 >/dev/null 2>&1 &)
chmod -R 755 /opt/challenge
