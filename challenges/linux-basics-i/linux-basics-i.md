---
name: linux-basics-i
display_name: Linux Basics I
description: RED-0 aligned labs — CLI, filesystem, pipes, search, plus theory quizzes via ./ask. Easy → medium → hard.
---

# Linux Basics I

Labs mapped to **RED-0 · Linux Basics I**. Six stations in one shared SSH environment: four practical keyword/`./checker` challenges and two theory quizzes you solve by launching `./ask` and typing answers (no file hunting required for those).

## Setup

1. Start the package from Hackploy.
2. SSH with the credentials shown on the platform.
3. `cd ~/challenges` and open each station folder.

## Stations

| # | Station | Difficulty | Flag method |
|---|---------|------------|-------------|
| 01 | Hidden Start | Easy | Find keyword → `./checker` |
| 02 | Shell Theory | Easy | `./ask` (type answers) |
| 03 | Path Maze | Medium | Find keyword → `./checker` |
| 04 | Log Pipeline | Medium | Find keyword → `./checker` |
| 05 | Search Web | Hard | Find keyword → `./checker` |
| 06 | Env & Man Theory | Hard | `./ask` (type answers) |

## Theory quizzes

```bash
cd ~/challenges/02-shell-theory   # or 06-env-theory
./ask
```

Answer each prompt. On success the script prints `CN{...}` — submit that flag on the site.

## Practical checkers

```bash
./checker '<keyword>'
```

## Curriculum links

Command line & listing → 01–02 · Filesystem paths → 03 · Pipes/redirection → 04 · find/grep → 05 · Environment & manuals → 06
