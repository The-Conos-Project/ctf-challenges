---
name: linux-basics
display_name: Linux Basics: The Ten-Step Trail
internal_port: 22
connection_type: ssh
flag_type: static
flag: flag{linux_basics_ten_steps_complete}
hints:
  - "Start with `cat /opt/linux-trail/START_HERE`."
  - "Each checkpoint tells you which Linux command family to practise next."
  - "The first nine flags confirm your progress. Submit the tenth and final flag to CTFploy."
---

# Linux Basics: The Ten-Step Trail

An approachable ten-checkpoint SSH lab for Linux fundamentals. Players follow a
clear trail while using `ls -la`, `cat`, `find`, `grep`, `base64`, `file`,
`zcat`, `pwd`, and executable permissions. The first nine flags show progress;
the tenth is the final platform submission flag.

## Connection

Connect via SSH on port 22.

## Start

Run `cat /opt/linux-trail/START_HERE` after connecting.
