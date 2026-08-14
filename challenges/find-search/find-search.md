---
name: find-search
display_name: Linux Find: Deep Search
description: Search the directory tree for files matching specific names.
flags:
  - flag: flag{find_hidden_treasure}
    description: Locate the file named secret_flag.txt in the directory structure.
    hints:
      - "Use the `find` command to search recursively."
      - "Run `find /opt/challenge -name 'secret_flag.txt'`."
---

# Linux Find: Deep Search

Search the directory tree for files matching specific names.

## Connection

Connect via SSH on port 22.

## Start

Run `cat /opt/challenge/START_HERE` after connecting.
