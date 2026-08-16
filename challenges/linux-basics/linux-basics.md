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
- Use the pwd command to print the current working directory.
- This shows you the full absolute path from root.

### Flag 2: Change to your home directory and confirm with pwd
**Hints:**
- Use cd ~ or just cd to return to your home directory.
- After changing directories, run pwd to verify.

### Flag 3: List all files in the current directory, including hidden ones
**Hints:**
- ls by default hides files starting with a dot.
- Use ls -a or ls -la to reveal hidden entries.

### Flag 4: Identify the type of a mystery file without reading its contents
**Hints:**
- The file command inspects magic bytes to determine file type.
- Try file mystery_binary in the challenge directory.

### Flag 5: Discover which manual section contains the passwd command reference
**Hints:**
- Use man passwd or man -k passwd to search.
- Section 5 often covers file formats like /etc/passwd.

### Flag 6: Locate the directory that contains system configuration files
**Hints:**
- The FHS places config files under /etc.
- Look for files like hosts, resolv.conf, or nginx.conf.

### Flag 7: Read the value of a hidden environment variable named SECRET_KEY
**Hints:**
- env and printenv list all environment variables.
- grep for SECRET_KEY in the output.

### Flag 8: Inspect your PATH variable and identify all directories searched for executables
**Hints:**
- echo $PATH shows the colon-separated list of directories.
- Each directory is checked in order when you run a command.

### Flag 9: Copy a template file and verify it exists in the destination
**Hints:**
- Use cp to copy files.
- Then use ls to verify the copy was created.

### Flag 10: Create a symbolic link and confirm it points to the correct target
**Hints:**
- ln -s target link_name creates a soft link.
- ls -l link_name shows the arrow pointing to the target.

### Flag 11: Create a hard link and verify both files share the same inode
**Hints:**
- ln target link_name creates a hard link.
- ls -i shows inode numbers; both files should match.

### Flag 12: Search recursively for a file named hidden_flag.txt
**Hints:**
- Use find /opt/challenges/find-nested -name 'hidden_flag.txt'.
- The file is buried several directories deep.

### Flag 13: Use locate to find a file named old_config.yaml
**Hints:**
- locate searches a prebuilt database.
- Run updatedb first if the file is very new.

### Flag 14: Redirect the output of a command into a file named result.txt
**Hints:**
- Use > to overwrite or >> to append.
- Try redirecting ls -la into result.txt.

### Flag 15: Use a pipe to count how many lines contain the word ERROR in a log file
**Hints:**
- grep ERROR access.log | wc -l counts matching lines.
- The pipe character | connects commands.

### Flag 16: Extract the third field from a colon-separated passwd-style file
**Hints:**
- cut -d: -f3 extracts the third colon-delimited field.
- Try it on /etc/passwd or a similar file.

### Flag 17: Find the home directory of the service account named sshd
**Hints:**
- grep sshd /etc/passwd shows the account line.
- The 6th colon-separated field is the home directory.

### Flag 18: Execute a command with elevated privileges using sudo
**Hints:**
- sudo runs commands as root.
- Try sudo cat /etc/shadow or sudo whoami.

### Flag 19: Make a file readable only by its owner using chmod
**Hints:**
- chmod 600 file gives read+write to owner only.
- Or use chmod u=r,go= file.

### Flag 20: Set the SUID bit on a binary and verify it with ls -l
**Hints:**
- chmod u+s /path/to/binary sets the SUID bit.
- In ls -l output, the owner execute bit shows as s.

### Flag 21: Find the PID of a running process named secret-daemon
**Hints:**
- pgrep secret-daemon returns the PID directly.
- ps aux | grep secret-daemon also works.

### Flag 22: Start a sleep process in the background and bring it back to foreground
**Hints:**
- sleep 300 & runs it in background.
- fg brings the most recent background job to foreground.

### Flag 23: List all cron jobs for the current user
**Hints:**
- crontab -l shows the current user's scheduled jobs.
- Look in /var/spool/cron/crontabs too.

### Flag 24: Find the most recent failed SSH login attempt in auth.log
**Hints:**
- grep 'Failed password' /var/log/auth.log shows failures.
- Use tail to see the most recent entries.

### Flag 25: Check the disk usage of the /home directory in human-readable format
**Hints:**
- du -sh /home shows the total size in a human-readable format.
- df -h shows filesystem disk space usage.
