---
name: grep-pattern
display_name: Linux Grep: Searching Logs
description: Filter and search log files for specific patterns.
---

# Linux Grep: Searching Logs

Filter and search log files for specific patterns.

## Flags

### Flag 1: Find the flag matching 'flag' inside the log file.
**Flag:** `flag{grep_success_pattern}`

**Hints:**
- Use the `grep` command.
- Run `grep flag /opt/challenge/access.log`.

### Flag 2: Find the flag with surrounding context lines.
**Flag:** `flag{grep_context_king}`

**Hints:**
- Use `grep -C 2 flag access.log`.
- Context helps confirm the right line.

