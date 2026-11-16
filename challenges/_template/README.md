# Hackploy challenge template

Rules for packages under `challenges/` for the Hackploy Hub / platform.

## Folder structure

Each package is one folder with exactly two Hub-facing files (plus optional `build/` source kept for authors):

```
challenges/
  <package-name>/
    <package-name>.tar.gz    # Docker build context
    <package-name>.md        # Hub description (front matter + markdown)
    build/                   # optional: editable source used to recreate the tar
```

Example:

```
challenges/
  linux-basics-i/
    linux-basics-i.tar.gz
    linux-basics-i.md
    build/
```

## tar.gz contents

At the **root** of the archive:

```
Dockerfile
setup.sh          # or bake content in Dockerfile RUN
hackploy.json
README.md
…                 # station files, lib/, etc. as needed
```

### hackploy.json

Manifest the platform reads. Prefer a `challenges` array for multi-station packages (see `linux-basics-i`).

```json
{
  "name": "my-lab",
  "display_name": "My Lab",
  "description": "What this package teaches.",
  "version": "1.0.0",
  "difficulty": "mixed",
  "category": "linux",
  "ports": { "ssh": 22 },
  "credentials": {
    "username": "user",
    "password": "user"
  },
  "challenges": [
    {
      "name": "station-a",
      "display_name": "01 · Station A",
      "description": "Easy — short goal.",
      "difficulty": "easy",
      "flag": "CN{example_flag_here}",
      "points": 100
    }
  ]
}
```

Rules:

- `name`: lowercase, hyphenated; matches folder / image tag prefix.
- Flags **must** be `CN{...}`.
- Credentials required for SSH labs.

## Two ways to earn a flag

### 1. Checker (practical)

Hide a **keyword** in the lab. Student runs:

```bash
./checker '<keyword>'
```

Wrong keyword → no flag. Store the expected keyword as a SHA-256 hash inside the checker so the plaintext flag is not sitting in a world-readable file.

### 2. Ask script (theory)

For conceptual RED-0 material, put an executable **`ask`** in the station folder root (plus `answers.env` with question text and answer hashes):

```bash
cd ~/challenges/02-shell-theory
./ask
```

Student types answers interactively. On success the script prints `CN{...}`. **Not every flag must be found by grepping the filesystem.**

Reference implementation: `linux-basics-i/build/lib/ask.sh` and stations `02-shell-theory`, `06-env-theory`.

## Difficulty

Per RED-0 module package aim for a mix: **couple easy, couple medium, then hard** — not a string of trivial `ls` toys.

## Dockerfile / SSH

- Ubuntu/Debian base, `openssh-server`, non-root user.
- Expose `22`; platform maps the port.
- Prefer baking lab content at **image build** time (`RUN setup.sh`) so start is reliable.

## Flag format

Only: `CN{...}`

## Rules summary

1. One Hub package = one folder with `.tar.gz` + `.md`.
2. Metadata file is **`hackploy.json`** (never `ctfploy.json`).
3. Support checker and/or `./ask` theory flows.
4. Test: `docker build`, run container, solve every station before push.
5. No real secrets, API keys, or private keys in the image.

## Submitting

1. Build/pack under `challenges/<name>/`.
2. Commit and push the Hub repo.
3. Platform / Hub sync picks up the new package.
