---
name: proc-inspect
display_name: Linux Processes: Inspect List
description: Inspect running system processes and their command line options.
---

# Linux Processes: Inspect List

Inspect running system processes and their command line options.

## Flags

### Flag 1: Find the secret flag in the arguments of a running process.
**Flag:** `flag{process_secret_id}`

**Hints:**
- Use the `ps` command to inspect running processes.
- Run `ps aux` or `ps -ef`.

### Flag 2: Find the PID of the secret process and inspect it.
**Flag:** `flag{pid_hunter}`

**Hints:**
- Use `pgrep` to find the process ID by name.
- Run `pgrep -f secret-agent`.

