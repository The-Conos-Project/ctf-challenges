---
name: network-check
display_name: Linux Ports: Local Connection
description: Interact with network socket interfaces on the local loopback.
---

# Linux Ports: Local Connection

Interact with network socket interfaces on the local loopback.

## Flags

### Flag 1: Talk to the local HTTP server running on port 8080.
**Flag:** `flag{local_port_handshake}`

**Hints:**
- Use `curl` or `nc` to connect to localhost.
- Run `curl http://127.0.0.1:8080`.

### Flag 2: Discover the service running on port 8080 without connecting.
**Flag:** `flag{port_scan_master}`

**Hints:**
- Use `ss` or `netstat` to list listening ports.
- Try `ss -tlnp`.

