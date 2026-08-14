#!/bin/bash
mkdir -p /opt/challenge/nested/level1/level2/level3/level4
echo "Find the file named secret_flag.txt hidden somewhere in this tree." > /opt/challenge/START_HERE
echo "flag{find_hidden_treasure}" > /opt/challenge/nested/level1/level2/level3/level4/secret_flag.txt
chmod -R 755 /opt/challenge
