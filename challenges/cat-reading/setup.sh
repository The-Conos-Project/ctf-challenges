#!/bin/bash
mkdir -p /opt/challenge
echo "Read the contents of the flag.txt file." > /opt/challenge/START_HERE
echo "flag{cat_content_revealed}" > /opt/challenge/flag.txt
chmod -R 755 /opt/challenge
