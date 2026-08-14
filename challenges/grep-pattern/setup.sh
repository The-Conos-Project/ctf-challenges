#!/bin/bash
mkdir -p /opt/challenge
echo "Find the line containing the flag in the access.log." > /opt/challenge/START_HERE
for i in {1..200}; do
    echo "127.0.0.1 - - [14/Aug/2026:08:59:$i] \"GET /index.html HTTP/1.1\" 200 4096" >> /opt/challenge/access.log
done
echo "192.168.1.5 - - [14/Aug/2026:09:00:00] \"POST /submit HTTP/1.1\" 200 flag{grep_success_pattern}" >> /opt/challenge/access.log
for i in {201..400}; do
    echo "127.0.0.1 - - [14/Aug/2026:09:01:$i] \"GET /styles.css HTTP/1.1\" 200 1024" >> /opt/challenge/access.log
done
chmod -R 755 /opt/challenge
