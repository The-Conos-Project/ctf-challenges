#!/bin/bash
mkdir -p /opt/challenge/restricted
echo "Try to read the file flag.txt inside /opt/challenge/restricted/." > /opt/challenge/START_HERE
echo "flag{permission_bypass}" > /opt/challenge/restricted/flag.txt
chmod 711 /opt/challenge/restricted
chmod 444 /opt/challenge/restricted/flag.txt
chmod 755 /opt/challenge
