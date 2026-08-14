#!/bin/bash
mkdir -p /opt/challenge
echo "Find the flag in the command execution history." > /opt/challenge/START_HERE
# Put history in profile skel so it defaults for new users
echo 'echo "flag{history_repeats_itself}"' >> /etc/skel/.bash_history
chmod -R 755 /opt/challenge
