---
name: linux-trail
display_name: Linux Training Trail
description: Master Linux fundamentals through 10 progressive challenges in a shared environment.
---

# Linux Training Trail

Master Linux fundamentals through 10 progressive challenges in a shared environment.

## Flags

### Flag 1: Inspect past terminal command execution records
**Hints:**
- Your shell keeps a history of the commands you have run.
- Look in your home directory for a hidden file that stores this history.
- Try the `history` builtin or inspect dotfiles in `~`.

### Flag 2: Read file contents in the terminal using standard utilities
**Hints:**
- There is a simple command to print file contents to the terminal.
- Look for a file named `flag.txt` inside the challenge directories.
- Check the current directory and its subdirectories.

### Flag 3: Read settings and flags configured via environment variables
**Hints:**
- Environment variables often store configuration or secrets.
- Use commands like `env` or `printenv` to list them.
- Search for variables with names like `SECRET` or `FLAG`.

### Flag 4: List all files in a directory, including hidden dotfiles
**Hints:**
- By default, some files are hidden from `ls`.
- Use a flag to show all entries, including those starting with `.`.
- Check the challenge directories carefully.

### Flag 5: Search the directory tree for files matching specific names
**Hints:**
- Use a command that can search recursively through directories.
- You can filter results by filename pattern.
- Look under `/opt/challenges` for files with names like `secret_flag.txt`.

### Flag 6: Filter and search log files for specific patterns
**Hints:**
- Use a text-search command to scan files for matching lines.
- Log files often contain useful clues.
- Look in directories named after the tool, such as `grep-pattern`.

### Flag 7: Interact with network socket interfaces on the local loopback
**Hints:**
- Services running on your own machine can be reached via `127.0.0.1`.
- Use tools like `curl` or `nc` to talk to local ports.
- Try common web ports like `8080` or `8000`.

### Flag 8: Practice executing files without having directory read access
**Hints:**
- Directory read permission lets you list files; execute permission lets you traverse it.
- You may not be able to list a restricted directory, but you can still access known paths inside it.
- Try accessing the flag file directly if you know its location.

### Flag 9: Inspect running system processes and their command line options
**Hints:**
- Use a command to list running processes and their arguments.
- Look for unusual or interesting command lines.
- Flags like `aux` or `ef` show more detail.

### Flag 10: Decompress tarballs and zip files in the terminal
**Hints:**
- Archives often contain the flag inside.
- Use `tar` to extract compressed archives.
- After extracting, search the output files for the flag.
