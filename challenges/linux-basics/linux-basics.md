---
name: linux-basics
display_name: Linux Basics: Hidden Files
description: Find a flag stored in a hidden file using basic directory listing.
flags:
  - flag: flag{linux_hidden_files}
    description: Locate and read the hidden checkpoint file.
    hints:
      - "Start with `ls -la /opt/linux-trail`."
---

# Linux Basics: Hidden Files

An approachable SSH lab that teaches `ls -la` and `cat`.

## Connection

Connect via SSH on port 22.

## Start

Run `cat /opt/linux-trail/START_HERE` after connecting.
