---
name: perm-check
display_name: Linux Permissions: Restrictive Execute
description: Practice executing files without having directory read access.
flags:
  - flag: flag{permission_bypass}
    description: Access the flag.txt file inside a directory you cannot list.
    hints:
      - "Directory read permission (`r`) allows listing files. Execute (`x`) allows traversing it."
      - "You cannot list `/opt/challenge/restricted/` but you can access `/opt/challenge/restricted/flag.txt` directly if you know the name."
---

# Linux Permissions: Restrictive Execute

Practice executing files without having directory read access.

## Connection

Connect via SSH on port 22.

## Start

Run `cat /opt/challenge/START_HERE` after connecting.
