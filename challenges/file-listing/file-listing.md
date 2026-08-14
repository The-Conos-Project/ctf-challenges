---
name: file-listing
display_name: Linux Listing: Hidden Checks
description: Learn to list all files in a directory, including hidden dotfiles.
---

# Linux Listing: Hidden Checks

Learn to list all files in a directory, including hidden dotfiles.

## Flags

### Flag 1: Find the hidden flag file in the challenge directory.
**Flag:** `flag{find_all_visible_files}`

**Hints:**
- Use `ls -la` to list all files.
- Files starting with a dot are hidden.

### Flag 2: Find the second hidden flag using glob patterns.
**Flag:** `flag{dotfiles_revealed}`

**Hints:**
- Try `echo .*` to see hidden files.
- Use `find` with `-name '.*'`.

