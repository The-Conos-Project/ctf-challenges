---
name: network-check
display_name: Linux Ports: Local Connection
description: Interact with network socket interfaces on the local loopback.
flags:
  - flag: flag{local_port_handshake}
    description: Talk to the local HTTP server running on port 8080.
    hints:
      - "Use `curl` or `nc` to connect to localhost."
      - "Run `curl http://127.0.0.1:8080`."
---

# Linux Ports: Local Connection

Interact with network socket interfaces on the local loopback.

## Connection

Connect via SSH on port 22.

## Start

Run `cat /opt/challenge/START_HERE` after connecting.
