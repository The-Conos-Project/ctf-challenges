---
name: tar-extract
display_name: Linux Tar: Extract Archives
description: Decompress tarballs and zip files in the terminal.
---

# Linux Tar: Extract Archives

Decompress tarballs and zip files in the terminal.

## Flags

### Flag 1: Decompress the challenge tar archive to read the flag.
**Flag:** `flag{archive_extracted_success}`

**Hints:**
- Use the `tar` utility.
- Run `tar -xf /opt/challenge/archive.tar.gz -C /tmp`.

### Flag 2: List the contents of the archive without extracting.
**Flag:** `flag{archive_contents_known}`

**Hints:**
- Use `tar -tzf archive.tar.gz` to list contents.
- The `t` flag lists contents, `z` handles gzip.

