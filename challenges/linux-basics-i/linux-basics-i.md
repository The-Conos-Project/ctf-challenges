---
name: linux-basics-i
display_name: Linux Basics I
description: Forty-two Linux basics stations — files, paths, search, pipes, permissions, env, archives, processes. Mixed difficulty, points, hints, checker and theory quizzes.
---

Linux Basics I

One SSH environment, 42 stations under ~/challenges. Mix of practical keyword/checker labs and interactive ./ask theory quizzes. Some challenges have platform hints, some do not. Points and difficulty vary.

Setup
1. Start the set from Hackploy.
2. SSH with the credentials shown.
3. cd ~/challenges and open each station README.

Flag methods
- Practical: find a keyword, then ./checker '<keyword>'
- Theory: run ./ask and type answers

Security notes for authors (also in the template)
- Never give students (ALL) NOPASSWD: ALL
- Ship checker/ask as execute-only compiled binaries, not readable shell scripts
- Flags stay CN{...}
