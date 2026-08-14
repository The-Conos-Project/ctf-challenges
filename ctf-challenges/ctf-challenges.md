# Linux Training Trail

A single Docker image containing 10 progressive Linux command-line challenges.

## Structure

- `Dockerfile` — Ubuntu 22.04 base with OpenSSH server and common CLI tools.
- `setup.sh` — Creates all challenge files under `/opt/challenges/` at container startup.
- `ctfploy.json` — Package metadata listing all 10 challenges with flags, descriptions, and hints.

## Challenges

| # | Name | Topic | Flags |
|---|------|-------|-------|
| 1 | bash-history | Inspecting shell history | 2 |
| 2 | cat-reading | Reading file contents | 2 |
| 3 | env-vars | Environment variables | 1 |
| 4 | file-listing | Hidden dotfiles | 2 |
| 5 | find-search | Recursive file search | 2 |
| 6 | grep-pattern | Log file filtering | 2 |
| 7 | network-check | Local port interaction | 2 |
| 8 | perm-check | Restrictive permissions | 1 |
| 9 | proc-inspect | Running process inspection | 2 |
| 10 | tar-extract | Archive decompression | 2 |

## Connection

All challenges share the same container image and are accessed via SSH on port 22. Each challenge directory lives under `/opt/challenges/<challenge-name>/`.

## Building

```bash
docker build -t ctf-linux-trail ./ctf-challenges
```

## Importing into CTFploy

Upload the `ctf-challenges.tar.gz` archive via the CTFploy admin interface. The platform will detect the multi-challenge `ctfploy.json` and register all 10 challenges automatically.
