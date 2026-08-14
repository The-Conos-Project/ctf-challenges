#!/bin/bash
mkdir -p /opt/challenge /tmp/build-arch
echo "flag{archive_extracted_success}" > /tmp/build-arch/flag.txt
tar -czf /opt/challenge/archive.tar.gz -C /tmp/build-arch flag.txt
rm -rf /tmp/build-arch
echo "Decompress the archive.tar.gz file in this directory." > /opt/challenge/START_HERE
chmod -R 755 /opt/challenge
