---
name: perm-check
display_name: Linux Permissions: Restrictive Execute
description: Practice executing files without having directory read access.
---

# Linux Permissions: Restrictive Execute

Practice executing files without having directory read access.

## Flags

### Flag 1: Access the flag.txt file inside a directory you cannot list.
**Flag:** `flag{permission_bypass}`

**Hints:**
- Directory read permission (`r`) allows listing files. Execute (`x`) allows traversing it.
- You cannot list `/opt/challenge/restricted/` but you can access `/opt/challenge/restricted/flag.txt` directly if you know the name.

