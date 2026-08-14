---
name: file-listing
display_name: Linux Listing: Hidden Checks
description: Learn to list all files in a directory, including hidden dotfiles.
flags:
  - flag: flag{find_all_visible_files}
    description: Find the hidden flag file in the challenge directory.
    hints:
      - "Use `ls -la` to list all files, including hidden ones."
      - "Files starting with a dot are hidden in Linux."
---

# Linux Listing: Hidden Checks

Learn to list all files in a directory, including hidden dotfiles.

## Connection

Connect via SSH on port 22.

## Start

Run `cat /opt/challenge/START_HERE` after connecting.
