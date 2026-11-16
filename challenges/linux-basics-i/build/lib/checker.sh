#!/bin/bash
# Usage: embed EXPECTED_HASH and FLAG before install, or pass via env at build.
set -euo pipefail
EXPECTED_HASH="${EXPECTED_HASH:?}"
FLAG="${FLAG:?}"

if [[ $# -lt 1 ]]; then
  echo "Usage: ./checker <keyword>"
  exit 1
fi

got=$(printf '%s' "$1" | sha256sum | awk '{print $1}')
if [[ "$got" == "$EXPECTED_HASH" ]]; then
  echo "$FLAG"
  exit 0
fi
echo "Wrong keyword. Keep looking."
exit 1
