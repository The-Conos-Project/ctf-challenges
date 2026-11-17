#!/bin/bash
set -euo pipefail
# Start helper used by the process-clue station (keyword in argv).
if ! pgrep -f 'lb-helper proc_clue_35' >/dev/null 2>&1; then
  nohup /usr/local/bin/lb-helper proc_clue_35 >/dev/null 2>&1 &
fi
exec /usr/sbin/sshd -D
