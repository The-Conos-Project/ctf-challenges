# 05 · Search Web (hard)

**RED-0:** Searching and Text Manipulation (`find`, `grep`).

## Goal

`web/` → `/opt/red0/web`. Locate the **production** `auth_token` value. That value is the checker keyword.

```bash
./checker '<keyword>'
```

Constraints are in `MISSION.txt`. Blind `grep -r needle` will hit decoys (`.git`, `backup/`, wrong numbers).

## Hints

1. `find … -name '*.cfg'` then `grep` beats grepping binaries in `vendor/`.
2. Exclude `.git` and `backup`.
3. Prefer the cfg that mentions prod.
