---
name: grep-pattern
display_name: Linux Grep: Searching Logs
description: Filter and search log files for specific patterns.
flags:
  - flag: flag{grep_success_pattern}
    description: Find the flag matching the string 'flag' inside the log file.
    hints:
      - "Use the `grep` command to search for matching text."
      - "Run `grep flag /opt/challenge/access.log`."
---

# Linux Grep: Searching Logs

Filter and search log files for specific patterns.

## Connection

Connect via SSH on port 22.

## Start

Run `cat /opt/challenge/START_HERE` after connecting.
