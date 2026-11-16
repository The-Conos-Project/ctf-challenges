# 04 · Log Pipeline (medium)

**RED-0:** Piping and Redirection.

## Goal

`logs/` points at `/var/log/app`. Ignore rotated `service.log.*` files. From `service.log`, isolate **ERROR** lines for user **ops**, then extract the `TOKEN=` value. That token is the checker keyword.

```bash
./checker '<keyword>'
```

Read `MISSION.txt` for the exact filter rules.

## Hints

1. `grep ERROR service.log | grep ops` is a start — still too wide.
2. Prefer `awk` if field positions help.
3. Decoy `FAIL_CODE_*` lines are not the token.
