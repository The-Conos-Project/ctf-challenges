---
name: tar-extract
display_name: Linux Tar: Extract Archives
description: Decompress tarballs and zip files in the terminal.
flags:
  - flag: flag{archive_extracted_success}
    description: Decompress the challenge tar archive to read the flag.
    hints:
      - "Use the `tar` utility to decompress archives."
      - "Run `tar -xf /opt/challenge/archive.tar.gz -C /tmp` and read the flag file."
---

# Linux Tar: Extract Archives

Decompress tarballs and zip files in the terminal.

## Connection

Connect via SSH on port 22.

## Start

Run `cat /opt/challenge/START_HERE` after connecting.
