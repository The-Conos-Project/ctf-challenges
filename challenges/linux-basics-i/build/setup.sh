#!/bin/bash
set -euo pipefail

USER_HOME=/home/user
CHALL="$USER_HOME/challenges"
ST=/tmp/stations

mkdir -p "$CHALL"

encrypt_flag() {
  # $1 = passphrase, $2 = plaintext flag → base64 ciphertext on stdout
  local pass="$1" flag="$2"
  printf '%s' "$flag" | openssl enc -aes-256-cbc -pbkdf2 -a -pass pass:"$pass" -A
}

install_checker() {
  local dest="$1" keyword="$2" flag="$3"
  local hash enc
  hash=$(printf '%s' "$keyword" | sha256sum | awk '{print $1}')
  enc=$(encrypt_flag "$keyword" "$flag")
  cat >"$dest/checker" <<EOF
#!/bin/bash
set -euo pipefail
EXPECTED_HASH='$hash'
FLAG_ENC='$enc'
if [[ \$# -lt 1 ]]; then
  echo "Usage: ./checker <keyword>"
  exit 1
fi
got=\$(printf '%s' "\$1" | sha256sum | awk '{print \$1}')
if [[ "\$got" != "\$EXPECTED_HASH" ]]; then
  echo "Wrong keyword. Keep looking."
  exit 1
fi
printf '%s' "\$FLAG_ENC" | openssl enc -d -aes-256-cbc -pbkdf2 -a -pass pass:"\$1" -A
echo
EOF
  chmod 755 "$dest/checker"
}

# answers file format: FLAG=... then ANSWER lines (plaintext, one per question) and Q lines
# We use answers.env with Qn / An_HASH — and a sibling answers.txt with raw answers for encryption key.
install_ask() {
  local dest="$1"
  local answers_env="$2"
  local answers_key="$3" # pipe-separated normalized answers for encrypt key

  # shellcheck disable=SC1090
  source "$answers_env"
  local key enc
  key=$(printf '%s' "$answers_key" | sha256sum | awk '{print $1}')
  enc=$(encrypt_flag "$key" "$FLAG")

  # Escape single quotes in questions for embedding
  esc() { printf '%s' "$1" | sed "s/'/'\\\\''/g"; }

  cat >"$dest/ask" <<EOF
#!/bin/bash
set -euo pipefail
FLAG_ENC='$enc'
Q1='$(esc "$Q1")'
A1_HASH='$A1_HASH'
Q2='$(esc "$Q2")'
A2_HASH='$A2_HASH'
Q3='$(esc "$Q3")'
A3_HASH='$A3_HASH'
Q4='$(esc "$Q4")'
A4_HASH='$A4_HASH'
Q5='$(esc "$Q5")'
A5_HASH='$A5_HASH'

normalize() {
  printf '%s' "\$1" | tr '[:upper:]' '[:lower:]' | sed 's/^[[:space:]]*//;s/[[:space:]]*\$//'
}
hash_ans() {
  normalize "\$1" | sha256sum | awk '{print \$1}'
}

echo
echo "=== Theory quiz ==="
echo "Answer each prompt. Spelling matters; case does not."
echo "Type q to abort."
echo

collected=""
i=1
while true; do
  q_var="Q\${i}"
  h_var="A\${i}_HASH"
  q="\${!q_var-}"
  h="\${!h_var-}"
  if [[ -z "\${q}" || -z "\${h}" ]]; then
    break
  fi
  while true; do
    printf "Q%d) %s\\n> " "\$i" "\$q"
    read -r ans || exit 1
    if [[ "\$ans" == "q" || "\$ans" == "Q" ]]; then
      echo "Aborted."
      exit 1
    fi
    if [[ "\$(hash_ans "\$ans")" == "\$h" ]]; then
      echo "Correct."
      echo
      n=\$(normalize "\$ans")
      if [[ -z "\$collected" ]]; then collected="\$n"; else collected="\$collected|\$n"; fi
      break
    fi
    echo "Not quite. Try again (or q to quit)."
  done
  i=\$((i + 1))
done

key=\$(printf '%s' "\$collected" | sha256sum | awk '{print \$1}')
echo "All answers accepted."
echo
printf 'FLAG: '
printf '%s' "\$FLAG_ENC" | openssl enc -d -aes-256-cbc -pbkdf2 -a -pass pass:"\$key" -A
echo
EOF
  chmod 755 "$dest/ask"
}

# ---------- 01 hidden-start (easy) ----------
D="$CHALL/01-hidden-start"
mkdir -p "$D/.cache/ops"
cp "$ST/01-hidden-start/README.md" "$D/README.md"
printf '%s\n' 'ghost_ls_a' >"$D/.cache/ops/token"
echo 'not this one' >"$D/notes.txt"
echo 'look for what ls hides' >"$D/.cache/README.txt"
install_checker "$D" 'ghost_ls_a' 'CN{red0_hidden_in_plain_sight}'

# ---------- 02 shell-theory (easy quiz) ----------
D="$CHALL/02-shell-theory"
mkdir -p "$D"
cp "$ST/02-shell-theory/README.md" "$D/README.md"
install_ask "$D" "$ST/02-shell-theory/answers.env" 'bash|pwd|/|ls|cat'

# ---------- 03 path-maze (medium) ----------
D="$CHALL/03-path-maze"
mkdir -p "$D"
cp "$ST/03-path-maze/README.md" "$D/README.md"
install_checker "$D" 'maze_exit_7f3a' 'CN{red0_absolute_paths_win}'

MAZE=/opt/red0/maze
mkdir -p "$MAZE"/{a/b/c,x/y/z,trap/loop,real/exit}
ln -sfn "$MAZE/a/b" "$MAZE/start"
ln -sfn "$MAZE/trap/loop" "$MAZE/a/b/next"
ln -sfn "$MAZE/a" "$MAZE/trap/loop/back"
ln -sfn /opt/red0/maze/real/exit "$MAZE/x/y/gate"
echo 'You followed a cycle. Try absolute paths from /opt/red0/maze' >"$MAZE/trap/loop/hint.txt"
echo 'warm — keep going via x/y' >"$MAZE/a/b/c/clue.txt"
echo 'gate is a symlink; resolve it' >"$MAZE/x/y/z/note.txt"
printf '%s\n' 'maze_exit_7f3a' >"$MAZE/real/exit/KEY"
chmod 644 "$MAZE/real/exit/KEY"
ln -sfn /opt/red0/maze "$D/maze"
echo 'Start: cd maze/start  (or use absolute /opt/red0/maze)' >"$D/HINT"

# ---------- 04 log-pipeline (medium) ----------
D="$CHALL/04-log-pipeline"
mkdir -p "$D" /var/log/app
cp "$ST/04-log-pipeline/README.md" "$D/README.md"
install_checker "$D" 'OPS_SIGNAL_91' 'CN{red0_pipes_cut_the_noise}'

{
  for i in $(seq 1 80); do
    echo "2024-01-01T12:00:$(printf '%02d' $((i%60))) INFO guest heartbeat-$i"
  done
  for i in $(seq 1 40); do
    echo "2024-01-01T12:01:$(printf '%02d' $((i%60))) WARN nginx timeout-$i"
  done
  echo "2024-01-01T12:02:10 ERROR root FAIL_CODE_00"
  echo "2024-01-01T12:02:11 ERROR daemon FAIL_CODE_11"
  echo "2024-01-01T12:02:12 ERROR ops FAIL_CODE_22"
  echo "2024-01-01T12:02:13 ERROR ops TOKEN=OPS_SIGNAL_91 detail=auth"
  echo "2024-01-01T12:02:14 ERROR ops FAIL_CODE_33"
  for i in $(seq 1 60); do
    echo "2024-01-01T13:00:$(printf '%02d' $((i%60))) DEBUG ops noise-$i"
  done
} > /var/log/app/service.log

for n in 1 2 3; do
  for i in $(seq 1 50); do
    echo "old ERROR guest junk-$n-$i"
  done > "/var/log/app/service.log.$n"
done
ln -sfn /var/log/app "$D/logs"
cat >"$D/MISSION.txt" <<'EOM'
Filter /var/log/app/service.log (not the rotated copies).
Keep only ERROR lines for user "ops".
From those, find the TOKEN=... value. That token is the checker keyword.
Hint: grep | grep | sed  — or awk.
EOM

# ---------- 05 search-web (hard) ----------
D="$CHALL/05-search-web"
mkdir -p "$D"
cp "$ST/05-search-web/README.md" "$D/README.md"
install_checker "$D" 'needle_in_hay_42' 'CN{red0_find_grep_patience}'

WEB=/opt/red0/web
mkdir -p "$WEB"/{assets,vendor,backup,tmp,.git/objects}
for i in $(seq 1 120); do
  echo "id=$i status=ok note=placeholder" >"$WEB/assets/item_$i.txt"
done
for i in $(seq 1 40); do
  printf 'PK\x03\x04fake-binary-%s' "$i" >"$WEB/vendor/lib_$i.bin"
done
echo 'needle_in_hay_00 is wrong' >"$WEB/backup/old_secret.txt"
echo 'almost needle_in_hay_41' >"$WEB/tmp/scratch.txt"
mkdir -p "$WEB/assets/deep/nested/config"
echo '# prod endpoint' >"$WEB/assets/deep/nested/config/app.cfg"
echo 'auth_token=needle_in_hay_42' >>"$WEB/assets/deep/nested/config/app.cfg"
echo 'auth_token=decoy' >"$WEB/assets/deep/nested/config/dev.cfg"
echo 'stage only' >"$WEB/assets/deep/nested/config/stage.cfg"
echo 'needle_in_hay_42' >"$WEB/.git/objects/pack_decoy"
ln -sfn /opt/red0/web "$D/web"
cat >"$D/MISSION.txt" <<'EOM'
Search /opt/red0/web for the production auth_token.
Rules of engagement:
  - Ignore .git and backup/
  - Prefer *.cfg under a prod-related file
  - Binary junk in vendor/ is a waste of time
The token value is your checker keyword.
EOM

# ---------- 06 env-theory (hard quiz) ----------
D="$CHALL/06-env-theory"
mkdir -p "$D"
cp "$ST/06-env-theory/README.md" "$D/README.md"
# answers normalized lowercase as ask stores them
install_ask "$D" "$ST/06-env-theory/answers.env" 'path|1|2>&1|export|env'

# ---------- MOTD / home ----------
cat >"$USER_HOME/START_HERE.md" <<'EOM'
# Linux Basics I — RED-0 lab

```bash
cd ~/challenges
ls
cat 01-hidden-start/README.md
```

Stations 02 and 06 use `./ask` (type answers → flag).
Others use `./checker <keyword>` after you find the keyword.
EOM

chown -R user:user "$USER_HOME"
chown -R root:root /opt/red0
chmod -R a+rX /opt/red0
chmod -R a+rX /var/log/app

echo "setup complete"
