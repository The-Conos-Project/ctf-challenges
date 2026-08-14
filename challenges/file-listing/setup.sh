#!/bin/bash
mkdir -p /opt/challenge
echo "Find the hidden file starting with a dot in this directory." > /opt/challenge/START_HERE
echo "This is just a decoy text file." > /opt/challenge/readme.txt
echo "flag{find_all_visible_files}" > /opt/challenge/.hidden_flag
chmod -R 755 /opt/challenge
