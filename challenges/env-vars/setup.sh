#!/bin/bash
mkdir -p /opt/challenge
echo "Check the environment variables of your shell." > /opt/challenge/START_HERE
echo "export SECRET_FLAG=flag{env_variable_found}" >> /etc/profile.d/flag.sh
chmod -R 755 /opt/challenge
