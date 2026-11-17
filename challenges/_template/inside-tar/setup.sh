#!/bin/bash
set -euo pipefail

# Example setup. Adapt for your stations.
# Rules:
# - Do not grant sudo ALL to the student user
# - Install checker/ask as root-owned mode 111 ELF binaries when possible
# - chmod/chown challenge files deliberately

USER_HOME=/home/user
mkdir -p "$USER_HOME/challenges/01-example"
cat >"$USER_HOME/challenges/01-example/README" <<'EOF'
Example station. Replace with a real task.
EOF

chown -R user:user "$USER_HOME"
echo "setup complete"
