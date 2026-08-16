# CTF Challenge Template

This folder contains the template and rules for creating new CTF challenges for the CTFploy platform.

## Folder Structure

Each challenge lives under `challenges/` as a single folder containing exactly two items:

```
challenges/
  <challenge-name>/
    <challenge-name>.tar.gz   # The Docker build artifact
    <challenge-name>.md       # The challenge description shown on the website
```

Example:

```
challenges/
  linux-trail/
    linux-trail.tar.gz
    linux-trail.md
  linux-basics/
    linux-basics.tar.gz
    linux-basics.md
```

## tar.gz Contents

Inside the `.tar.gz` archive, include exactly these files:

```
Dockerfile
setup.sh
ctfploy.json
README.md
```

### Dockerfile

- Base image: `ubuntu:22.04` (or `debian:bookworm-slim` for smaller images)
- Install only the packages needed for the challenge
- Create a non-root SSH user (credentials are injected by the platform)
- Copy `setup.sh` into the image
- Expose port `22`
- Run `setup.sh` on container start, then start `sshd`

Example:

```dockerfile
FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y openssh-server <other-packages> && rm -rf /var/lib/apt/lists/*
RUN mkdir -p /var/run/sshd /run/sshd
RUN sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config
RUN sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
RUN ssh-keygen -A && sshd -t
COPY setup.sh /usr/local/bin/setup.sh
RUN chmod +x /usr/local/bin/setup.sh
EXPOSE 22
CMD ["/bin/sh", "-c", "/usr/local/bin/setup.sh && echo 'setup complete' && exec /usr/sbin/sshd -D -e"]
```

### setup.sh

- This script sets up the challenge environment inside the container
- It runs **every time the container starts**
- Use the `CHALLENGE_NAME` environment variable to support multiple challenges in one image (optional)
- Create challenge directories under `/opt/challenges/`
- Place the flag content in files where students can discover them
- Do **not** hardcode credentials; the platform injects `SSH_USER` and `SSH_PASSWORD` at runtime

**Important:**
- Do **not** use `exit 0` inside the `CHALLENGE_NAME` case block if more setup must run afterwards. An unexpected or missing `CHALLENGE_NAME` can cause the script to terminate before creating required directories.
- Always guard cleanup commands (`chmod`, `rm`, `find`, etc.) with existence checks: `if [ -d /path ]; then ...; fi`
- When a `CHALLENGE_NAME` is provided but does not match any case, fall back to setting up all challenges or print a warning and continue.

Example structure:

```bash
#!/bin/bash
set -e

CHALLENGE_NAME="${CHALLENGE_NAME:-}"

if [[ -n "$CHALLENGE_NAME" ]]; then
    case "$CHALLENGE_NAME" in
        my-challenge) setup_my_challenge ;;
        *) echo "Unknown challenge: $CHALLENGE_NAME; setting up all challenges." ;;
    esac
fi

# Always ensure required directories and files exist.
setup_my_challenge
setup_another_challenge

# Optional cleanup; guard with existence check.
if [ -d /opt/challenges ]; then
    find /opt/challenges -type d -exec chmod 755 {} \;
fi
```

### ctfploy.json

This is the manifest the platform reads to understand the challenge:

```json
{
  "name": "linux-trail",
  "display_name": "Linux Training Trail",
  "description": "Master Linux fundamentals through 10 progressive challenges in a shared environment.",
  "credentials": {
    "username": "ctfuser",
    "password": "changeme123"
  },
  "flags": [
    {
      "flag": "CN{example_flag_here}",
      "points": 4,
      "max_attempts": 5,
      "description": "Short description of what the student must do.",
      "hints": [
        "First generic hint pointing toward the right tool or concept.",
        "Second generic hint with slightly more direction.",
        "Third hint that clarifies the exact path or command without being a full walkthrough."
      ]
    }
  ]
}
```

**Rules for ctfploy.json:**
- `name`: lowercase, no spaces, used as the folder name and image tag prefix
- `display_name`: human-readable title shown on the website
- `description`: 1-2 sentences explaining the challenge
- `credentials`: **required**. Must include `username` (3-32 chars, lowercase/numbers/underscores/hyphens) and `password` (1-128 chars). The platform injects these into the container at runtime.
- `flags`: array of flag objects
  - `flag`: **must** start with `CN{` and end with `}`
  - `points`: positive integer, score awarded on successful submission
  - `max_attempts`: positive integer, maximum allowed submissions before locking the flag
  - `description`: what the student needs to accomplish
  - `hints`: array of 2-3 hints, ordered from vague to specific

### README.md

- Shown on the challenge page before the student starts the container
- Include a brief overview, what topics are covered, and a list of flags with hints
- Keep it clean and professional

## Flag Format

**All flags must use the format:** `CN{...}`

Examples:
- `CN{path_to_current_directory}`
- `CN{grep_success_pattern}`
- `CN{special_permission_set}`

Do **not** use `flag{...}` or any other format.

## Hint Guidelines

Hints should guide without spoiling. Follow these rules:

1. **First hint:** Very generic. Point toward the right command or concept. Do not mention file paths or exact syntax.
2. **Second hint:** More specific. Mention the general area (e.g., "look in /etc") or the tool category (e.g., "text search utilities").
3. **Third hint:** Almost a walkthrough but still require the student to type the command. Mention filenames or paths if necessary.

**Bad hints (too obvious):**
- "Run `cat flag.txt` to get the flag"
- "The flag is in /home/user/flag.txt"
- "Type `ls -la` and read the hidden file"

**Good hints (generic):**
- "Text files can reveal their contents when read properly."
- "Some files are hidden from casual observers."
- "Look for files that the shell stores automatically."

## Rules Summary

1. **One challenge = one folder** inside `challenges/`
2. **Exactly two items** in the folder: `.tar.gz` and `.md`
3. **Inside the tar.gz:** `Dockerfile`, `setup.sh`, `ctfploy.json`, `README.md`
4. **Flag format:** `CN{...}`
5. **Hints:** Generic, not obvious. Do not give away the exact command.
6. **No secrets in code:** Do not embed real credentials, API keys, or private keys.
7. **SSH only:** The platform connects via SSH on port 22. Do not expose web services unless the challenge requires it.
8. **Clean up:** Remove temporary files, build artifacts, and sensitive data before packaging.
9. **Test locally:** Build the Docker image, start a container, and verify all flags are solvable before submitting.
10. **Single purpose:** Each challenge should test one or two related concepts. Avoid cramming unrelated tasks into one challenge.

## Submitting

1. Create your challenge folder under `challenges/`
2. Add the `.tar.gz` and `.md` files
3. Commit and push to the repository
4. The platform will automatically detect the new challenge on the next sync
