---
name: find-search
display_name: Linux Find: Deep Search
description: Search the directory tree for files matching specific names.
---

# Linux Find: Deep Search

Search the directory tree for files matching specific names.

## Flags

### Flag 1: Locate secret_flag.txt in the directory structure.
**Flag:** `flag{find_hidden_treasure}`

**Hints:**
- Use the `find` command to search recursively.
- Run `find /opt/challenge -name 'secret_flag.txt'`.

### Flag 2: Find all flag files in the challenge directory tree.
**Flag:** `flag{find_all_treasures}`

**Hints:**
- Use `find` with `-name '*flag*'`.
- Combine `find` with `xargs`.

