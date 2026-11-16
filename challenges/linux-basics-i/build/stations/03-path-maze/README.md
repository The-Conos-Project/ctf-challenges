# 03 · Path Maze (medium)

**RED-0:** Filesystem — absolute vs relative paths, symlinks, navigation.

## Goal

Enter the maze (symlink in this folder → `/opt/red0/maze`). Symlink loops and relative `cd` will waste your time. Resolve the real exit and read the **KEY** file. That string is the checker keyword.

```bash
./checker '<keyword>'
```

## Hints

1. `pwd -P` and `readlink -f` show where you actually are.
2. Cycles exist on purpose — break them with absolute paths.
3. The exit is under `real/`, not under `trap/`.
