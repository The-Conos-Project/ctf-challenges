#!/bin/bash
set -e

CHALLENGE_NAME="${CHALLENGE_NAME:-}"

if [[ -n "$CHALLENGE_NAME" ]]; then
    case "$CHALLENGE_NAME" in
        my-challenge) setup_my_challenge ;;
        *) echo "Unknown challenge: $CHALLENGE_NAME" ;;
    esac
    exit 0
fi

# Default: set up all challenges
setup_my_challenge

# Optional: set permissions so students can read challenge files
chmod -R a=rX /opt/challenges
find /opt/challenges -type d -exec chmod 755 {} \;
