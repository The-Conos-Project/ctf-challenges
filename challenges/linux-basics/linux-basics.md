---
name: linux-basics
display_name: Linux Basics
description: Master Linux fundamentals through 25 progressive challenges in a shared environment.
---

# Linux Basics

Master Linux fundamentals through 25 progressive challenges in a shared environment.

## Setup

1. Start the container from CTFploy.
2. Connect via SSH using the credentials shown in the platform.
3. Explore the environment to find the flags.

## How it works

Each challenge has a hidden **keyword** somewhere in the system. Use Linux
commands to discover the keyword, then run the checker to get the flag:

```bash
./checker <keyword>
```

If the keyword is correct, the checker prints the flag. You can also submit
the flag directly on the website if you already know it.

## Structure

Inside the container, challenges are organized under `/home/ctfuser/challenges/`:

```
/home/ctfuser/challenges/
  flag1/
    README.md
    checker
  flag2/
    README.md
    checker
  ...
  flag25/
    README.md
    checker
```

Each `checker` is a root-owned validation script. Run it with the keyword you
discover to get the flag, or run it with the flag itself to validate:

```bash
./checker falcon          # returns: Flag: CN{find_nested_flag_file}
./checker CN{find_nested_flag_file}  # returns: Correct!
```

## Flags

### Flag 1: Print the absolute path of your current working directory
**Keyword:** `pwdpath` (hidden in the system)
**Hints:**
- The terminal can tell you where you are.
- A common builtin prints the working directory.

### Flag 2: Change to your home directory and confirm your location
**Keyword:** `homebase` (hidden in the system)
**Hints:**
- There is a shortcut to return to your home directory.
- Verify your location after moving.

### Flag 3: List all files in the current directory, including hidden ones
**Keyword:** `invisible` (hidden in the system)
**Hints:**
- Not everything is shown by default.
- Some entries begin with a dot.

### Flag 4: Identify the type of a mystery file without reading its contents
**Keyword:** `magicbytes` (hidden in the system)
**Hints:**
- Magic bytes reveal file types.
- A common utility can inspect file headers.

### Flag 5: Discover which manual section contains the passwd command reference
**Keyword:** `manpages` (hidden in the system)
**Hints:**
- Built-in documentation is organized into sections.
- System file formats often live in section 5.

### Flag 6: Locate the directory that contains system configuration files
**Keyword:** `rootfs` (hidden in the system)
**Hints:**
- The standard hierarchy groups configuration under one top-level directory.
- Look for files like hosts, resolv.conf, or similar system files.

### Flag 7: Read the value of a hidden environment variable named SECRET_KEY
**Keyword:** `secretvalue` (hidden in the system)
**Hints:**
- Processes inherit settings from their environment.
- List environment variables and search for SECRET_KEY.

### Flag 8: Inspect your PATH variable and identify all directories searched for executables
**Keyword:** `usrbin` (hidden in the system)
**Hints:**
- The shell searches a list of directories when you run a command.
- This list is stored in a variable and separated by colons.

### Flag 9: Copy a template file and verify it exists in the destination
**Keyword:** `templatecopy` (hidden in the system)
**Hints:**
- Standard file duplication command.
- Confirm the new file exists.

### Flag 10: Create a symbolic link and confirm it points to the correct target
**Keyword:** `symbolic` (hidden in the system)
**Hints:**
- A pointer file can reference another path.
- List the link to see its target.

### Flag 11: Create a hard link and verify both files share the same inode
**Keyword:** `hardlink` (hidden in the system)
**Hints:**
- Two names can reference the same underlying data.
- Inode numbers remain identical.

### Flag 12: Search recursively for a file named hidden_flag.txt
**Keyword:** `falcon` (hidden deep in the filesystem)
**Hints:**
- Recursive search is faster than manual exploration.
- Filter by filename pattern.

### Flag 13: Use locate to find a file named old_config.yaml
**Keyword:** `locatedb` (hidden in the system)
**Hints:**
- An indexed database can speed up searches.
- The database may need updating first.

### Flag 14: Redirect the output of a command into a file named result.txt
**Keyword:** `redirected` (hidden in the system)
**Hints:**
- Send command output to a file.
- Overwrite or append as needed.

### Flag 15: Use a pipe to count how many lines contain the word ERROR in a log file
**Keyword:** `pipeline` (hidden in the system)
**Hints:**
- Connect commands together.
- Count matching lines without opening the file.

### Flag 16: Extract the third field from a colon-separated passwd-style file
**Keyword:** `delimiter` (hidden in the system)
**Hints:**
- Delimited text can be split by column.
- The third field often stores a numeric ID.

### Flag 17: Find the home directory of the service account named sshd
**Keyword:** `sshduser` (hidden in the system)
**Hints:**
- System accounts are listed in a central database.
- The 6th field usually holds the home directory.

### Flag 18: Execute a command with elevated privileges using sudo
**Keyword:** `sudoaccess` (hidden in the system)
**Hints:**
- Run commands as another user, typically root.
- You may need to know the password.

### Flag 19: Make a file readable only by its owner using chmod
**Keyword:** `sixhundred` (hidden in the system)
**Hints:**
- Numeric or symbolic modes can restrict access.
- Owner gets read+write; others get nothing.

### Flag 20: Set the SUID bit on a binary and verify it with ls -l
**Keyword:** `setuidbit` (hidden in the system)
**Hints:**
- A special bit can make a binary run as its owner.
- In long listings, the owner execute bit may show as s.

### Flag 21: Find the PID of a running process named secret-daemon
**Keyword:** `daemonpid` (hidden in the system)
**Hints:**
- Process IDs can be queried directly by name.
- The process table also reveals command lines.

### Flag 22: Start a sleep process in the background and bring it back to foreground
**Keyword:** `backgroundjob` (hidden in the system)
**Hints:**
- Run a long process without blocking the terminal.
- Return it to the foreground when needed.

### Flag 23: List all cron jobs for the current user
**Keyword:** `cronminute` (hidden in the system)
**Hints:**
- Scheduled tasks can be queried per user.
- Look in spool directories too.

### Flag 24: Find the most recent failed SSH login attempt in auth.log
**Keyword:** `failedlogin` (hidden in the system)
**Hints:**
- Authentication logs record failed attempts.
- Filter and view the tail of the log.

### Flag 25: Check the disk usage of the /home directory in human-readable format
**Keyword:** `diskfree` (hidden in the system)
**Hints:**
- Summarize directory sizes or filesystem usage.
- Human-readable output helps interpretation.
