---
name: cat-reading
display_name: Linux Reading: File Contents
description: Read file contents in the terminal using standard utilities.
flags:
  - flag: flag{cat_content_revealed}
    description: Print the contents of the flag file to reveal the secret.
    hints:
      - "Use the `cat` command to read file contents."
      - "The target file is `flag.txt`."
---

# Linux Reading: File Contents

Read file contents in the terminal using standard utilities.

## Connection

Connect via SSH on port 22.

## Start

Run `cat /opt/challenge/START_HERE` after connecting.
