---
name: bash-history
display_name: Linux History: Past Logs
description: Inspect past terminal command execution records.
flags:
  - flag: flag{history_repeats_itself}
    description: Find the flag in the command execution history.
    hints:
      - "Check the `.bash_history` file."
      - "Look in the home directory or run the `history` command."
---

# Linux History: Past Logs

Inspect past terminal command execution records.

## Connection

Connect via SSH on port 22.

## Start

Run `cat /opt/challenge/START_HERE` after connecting.
