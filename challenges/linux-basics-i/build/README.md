# Linux Basics I (RED-0)

Hands-on labs aligned with **RED-0 · Linux Basics I**. Six stations: two easy, two medium, two hard. Some flags come from filesystem work; others from a local `./ask` quiz script.

## Connect

1. Launch from Hackploy Hub / platform.
2. SSH in with the credentials shown (default build: `user` / `user`).
3. Start at `~/challenges/`.

```bash
ssh user@<host> -p <port>
cd ~/challenges
ls
```

## Station map

| # | Folder | Diff | How you get the flag |
|---|--------|------|----------------------|
| 01 | `01-hidden-start` | Easy | Find keyword → `./checker <keyword>` |
| 02 | `02-shell-theory` | Easy | `./ask` — type answers |
| 03 | `03-path-maze` | Medium | Find keyword → `./checker <keyword>` |
| 04 | `04-log-pipeline` | Medium | Find keyword → `./checker <keyword>` |
| 05 | `05-search-web` | Hard | Find keyword → `./checker <keyword>` |
| 06 | `06-env-theory` | Hard | `./ask` — type answers |

## Theory quizzes (`./ask`)

Not every flag is buried in a file. For theory stations, run the script in that folder and answer prompts. Correct answers unlock the flag printed to stdout — submit that flag on the platform.

```bash
cd ~/challenges/02-shell-theory
./ask
```

## Checkers

Practical stations hide a **keyword**. When you find it:

```bash
./checker '<keyword>'
```

Wrong keyword → no flag. Right keyword → prints `CN{...}`.

## Curriculum map (RED-0)

- Command line / shells → 01, 02  
- Filesystem & paths → 03  
- Pipes & redirection → 04  
- Searching & text → 05  
- Environment + manuals → 06  
