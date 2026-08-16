---
name: linux-basics
display_name: Linux Basics
description: Master Linux fundamentals through 25 progressive challenges in a shared environment.
---

# Linux Basics

Master Linux fundamentals through 25 progressive challenges in a shared environment.

## Flags

### Flag 1: Print the absolute path of your current working directory
**Hints:**
- The terminal can tell you where you are.
- A common builtin prints the working directory.

### Flag 2: Change to your home directory and confirm your location
**Hints:**
- There is a shortcut to return to your home directory.
- Verify your location after moving.

### Flag 3: List all files in the current directory, including hidden ones
**Hints:**
- Not everything is shown by default.
- Some entries begin with a dot.

### Flag 4: Identify the type of a mystery file without reading its contents
**Hints:**
- Magic bytes reveal file types.
- A common utility can inspect file headers.

### Flag 5: Discover which manual section contains the passwd command reference
**Hints:**
- Built-in documentation is organized into sections.
- System file formats often live in section 5.

### Flag 6: Locate the directory that contains system configuration files
**Hints:**
- The standard hierarchy groups configuration under one top-level directory.
- Look for files like hosts, resolv.conf, or similar system files.

### Flag 7: Read the value of a hidden environment variable named SECRET_KEY
**Hints:**
- Processes inherit settings from their environment.
- List environment variables and search for SECRET_KEY.

### Flag 8: Inspect your PATH variable and identify all directories searched for executables
**Hints:**
- The shell searches a list of directories when you run a command.
- This list is stored in a variable and separated by colons.

### Flag 9: Copy a template file and verify it exists in the destination
**Hints:**
- Standard file duplication command.
- Confirm the new file exists.

### Flag 10: Create a symbolic link and confirm it points to the correct target
**Hints:**
- A pointer file can reference another path.
- List the link to see its target.

### Flag 11: Create a hard link and verify both files share the same inode
**Hints:**
- Two names can reference the same underlying data.
- Inode numbers remain identical.

### Flag 12: Search recursively for a file named hidden_flag.txt
**Hints:**
- Recursive search is faster than manual exploration.
- Filter by filename pattern.

### Flag 13: Use locate to find a file named old_config.yaml
**Hints:**
- An indexed database can speed up searches.
- The database may need updating first.

### Flag 14: Redirect the output of a command into a file named result.txt
**Hints:**
- Send command output to a file.
- Overwrite or append as needed.

### Flag 15: Use a pipe to count how many lines contain the word ERROR in a log file
**Hints:**
- Connect commands together.
- Count matching lines without opening the file.

### Flag 16: Extract the third field from a colon-separated passwd-style file
**Hints:**
- Delimited text can be split by column.
- The third field often stores a numeric ID.

### Flag 17: Find the home directory of the service account named sshd
**Hints:**
- System accounts are listed in a central database.
- The 6th field usually holds the home directory.

### Flag 18: Execute a command with elevated privileges using sudo
**Hints:**
- Run commands as another user, typically root.
- You may need to know the password.

### Flag 19: Make a file readable only by its owner using chmod
**Hints:**
- Numeric or symbolic modes can restrict access.
- Owner gets read+write; others get nothing.

### Flag 20: Set the SUID bit on a binary and verify it with ls -l
**Hints:**
- A special bit can make a binary run as its owner.
- In long listings, the owner execute bit may show as s.

### Flag 21: Find the PID of a running process named secret-daemon
**Hints:**
- Process IDs can be queried directly by name.
- The process table also reveals command lines.

### Flag 22: Start a sleep process in the background and bring it back to foreground
**Hints:**
- Run a long process without blocking the terminal.
- Return it to the foreground when needed.

### Flag 23: List all cron jobs for the current user
**Hints:**
- Scheduled tasks can be queried per user.
- Look in spool directories too.

### Flag 24: Find the most recent failed SSH login attempt in auth.log
**Hints:**
- Authentication logs record failed attempts.
- Filter and view the tail of the log.

### Flag 25: Check the disk usage of the /home directory in human-readable format
**Hints:**
- Summarize directory sizes or filesystem usage.
- Human-readable output helps interpretation.
