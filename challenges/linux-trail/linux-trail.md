---
name: linux-trail
display_name: Linux Training Trail
description: Master Linux fundamentals through 10 progressive challenges in a shared environment.
---

# Linux Training Trail

Master Linux fundamentals through 10 progressive challenges in a shared environment.

## Flags

### Flag 1: Inspect past terminal command execution records
**Flag:** `CN{history_repeats_itself}`

**Hints:**
- Bash keeps a record of commands you type.
- History might be stored in a hidden file in your home directory.
- Try the `history` builtin or look for dotfiles.

### Flag 2: Read file contents in the terminal using standard utilities
**Flag:** `CN{cat_content_revealed}`

**Hints:**
- Use the `cat` command to read file contents.
- The target file is `flag.txt` in the challenge directory.

### Flag 3: Read settings and flags configured via environment variables
**Flag:** `CN{env_variable_found}`

**Hints:**
- Run the `env` or `printenv` commands.
- Search for the variable names matching 'SECRET_FLAG'.

### Flag 4: List all files in a directory, including hidden dotfiles
**Flag:** `CN{find_all_visible_files}`

**Hints:**
- Use `ls -la` to list all files, including hidden ones.
- Files starting with a dot are hidden in Linux.

### Flag 5: Search the directory tree for files matching specific names
**Flag:** `CN{find_hidden_treasure}`

**Hints:**
- Use the `find` command to search recursively.
- Run `find /opt/challenges/find-search -name 'secret_flag.txt'`.

### Flag 6: Filter and search log files for specific patterns
**Flag:** `CN{grep_success_pattern}`

**Hints:**
- Use the `grep` command to search for matching text.
- Run `grep flag /opt/challenges/grep-pattern/access.log`.

### Flag 7: Interact with network socket interfaces on the local loopback
**Flag:** `CN{local_port_handshake}`

**Hints:**
- Use `curl` or `nc` to connect to localhost.
- Run `curl http://127.0.0.1:8080`.

### Flag 8: Practice executing files without having directory read access
**Flag:** `CN{permission_bypass}`

**Hints:**
- Directory read permission (`r`) allows listing files. Execute (`x`) allows traversing it.
- You cannot list `/opt/challenges/perm-check/restricted/` but you can access `/opt/challenges/perm-check/restricted/flag.txt` directly if you know the name.

### Flag 9: Inspect running system processes and their command line options
**Flag:** `CN{process_secret_id}`

**Hints:**
- Use the `ps` command to inspect running processes.
- Run `ps aux` or `ps -ef` to see command line arguments.

### Flag 10: Decompress tarballs and zip files in the terminal
**Flag:** `CN{archive_extracted_success}`

**Hints:**
- Use the `tar` utility to decompress archives.
- Run `tar -xf /opt/challenges/tar-extract/archive.tar.gz -C /tmp` and read the flag file.
