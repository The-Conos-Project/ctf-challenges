#!/bin/bash
set -euo pipefail

USER_HOME=/home/user
CHALL="$USER_HOME/challenges"
TOOLS=/tmp/tools
OPT=/opt/lb
mkdir -p "$CHALL" "$OPT"

sha256() { printf '%s' "$1" | sha256sum | awk '{print $1}'; }

xor_hex() {
  python3 -c 'import hashlib,sys; flag,key_m=sys.argv[1],sys.argv[2]; key=hashlib.sha256(key_m.encode()).digest(); raw=flag.encode(); print("".join(f"{b^key[i%len(key)]:02x}" for i,b in enumerate(raw)))' "$1" "$2"
}

compile_checker() {
  local dest="$1" keyword="$2" flag="$3"
  local hash xor flen
  hash=$(sha256 "$keyword")
  xor=$(xor_hex "$flag" "$keyword")
  flen=${#flag}
  gcc -O2 -s -o "$dest/checker" "$TOOLS/checker.c" \
    -DEXPECTED_HASH="\"$hash\"" \
    -DFLAG_XOR_HEX="\"$xor\"" \
    -DFLAG_LEN="$flen" \
    -lcrypto
  chown root:root "$dest/checker"
  chmod 111 "$dest/checker"
}

write_ask_header() {
  # $1=outdir $2=flag $3=key_material $4=json file of [[q,a],...]
  python3 - "$1" "$2" "$3" "$4" <<'PY'
import hashlib, json, sys
out_dir, flag, key_m, qa_path = sys.argv[1:5]
pairs = json.loads(open(qa_path).read())
key = hashlib.sha256(key_m.encode()).digest()
raw = flag.encode()
xor = "".join(f"{b ^ key[i % len(key)]:02x}" for i, b in enumerate(raw))
def c_str(s: str) -> str:
    return json.dumps(s)
lines = ["#ifndef ASK_DATA_H", "#define ASK_DATA_H", f"#define N_QUESTIONS {len(pairs)}", "static const char *Q_TEXTS[N_QUESTIONS] = {"]
for q, a in pairs:
    lines.append(f"  {c_str(q)},")
lines.append("};")
lines.append("static const char *A_HASHES[N_QUESTIONS] = {")
for q, a in pairs:
    h = hashlib.sha256(a.encode()).hexdigest()
    lines.append(f"  {c_str(h)},")
lines.append("};")
lines.append(f"#define FLAG_XOR_HEX {c_str(xor)}")
lines.append(f"#define FLAG_LEN {len(raw)}")
lines.append("#endif")
open(f"{out_dir}/ask_data.h", "w").write("\n".join(lines) + "\n")
PY
}

compile_ask() {
  local dest="$1" flag="$2" key_material="$3" qa_json="$4"
  local tmp="$dest/.ask_build"
  mkdir -p "$tmp"
  write_ask_header "$tmp" "$flag" "$key_material" "$qa_json"
  gcc -O2 -s -I"$tmp" -o "$dest/ask" "$TOOLS/ask.c" -lcrypto
  chown root:root "$dest/ask"
  chmod 111 "$dest/ask"
  rm -rf "$tmp" "$qa_json"
}

# ---------- group for group-readable secret ----------
groupadd -f labusers
usermod -aG labusers user


# ---------- 01-hidden-dotfiles ----------
D="$CHALL/01-hidden-dotfiles"
mkdir -p "$D"
cat >"$D/README" <<'EOF'
Something in this folder is hidden from a plain ls.
Find the keyword file, then run: ./checker '<keyword>'
EOF
cat >"$D/HINT" <<'EOF'
ls alone is not enough.
EOF
compile_checker "$D" 'ghost_ls_a' 'CN{lb_hidden_dotfiles}'
mkdir -p "$D/.cache/ops"
printf '%s\n' 'ghost_ls_a' >"$D/.cache/ops/token"
echo 'not this one' >"$D/notes.txt"
echo 'look for what ls hides' >"$D/.cache/README.txt"

# ---------- 02-cat-readme ----------
D="$CHALL/02-cat-readme"
mkdir -p "$D"
cat >"$D/README" <<'EOF'
Read note.txt. The KEYWORD= line is what ./checker wants.
EOF
compile_checker "$D" 'open_sesame_cat' 'CN{lb_cat_the_note}'
printf 'KEYWORD=%s\n' 'open_sesame_cat' >"$D/note.txt"

# ---------- 03-head-log ----------
D="$CHALL/03-head-log"
mkdir -p "$D"
cat >"$D/README" <<'EOF'
big.log is noisy. The keyword is early in the file as TOKEN=...
EOF
compile_checker "$D" 'HEAD_TOKEN_7' 'CN{lb_head_sees_first}'
{
  echo 'TOKEN=HEAD_TOKEN_7'
  for i in $(seq 1 200); do echo "noise line $i"; done
} >"$D/big.log"

# ---------- 04-tail-secret ----------
D="$CHALL/04-tail-secret"
mkdir -p "$D"
cat >"$D/README" <<'EOF'
trail.log ends with the keyword. Use a tool that reads the end of a file.
EOF
compile_checker "$D" 'TAIL_OK_99' 'CN{lb_tail_sees_last}'
{
  for i in $(seq 1 200); do echo "noise line $i"; done
  echo 'TAIL_OK_99'
} >"$D/trail.log"

# ---------- 05-wc-lines ----------
D="$CHALL/05-wc-lines"
mkdir -p "$D"
cat >"$D/README" <<'EOF'
Count the lines in data.txt. The keyword is: lines_are_<COUNT>
EOF
cat >"$D/HINT" <<'EOF'
wc -l
EOF
compile_checker "$D" 'lines_are_120' 'CN{lb_wc_counts}'
for i in $(seq 1 120); do echo "row-$i"; done >"$D/data.txt"

# ---------- 06-pwd-theory ----------
D="$CHALL/06-pwd-theory"
mkdir -p "$D"
cat >"$D/README" <<'EOF'
No file hunting. Run ./ask and answer each question.
EOF
cat >/tmp/qa_pwd-theory.json <<'EOF'
[["On many Linux distros, what is the default interactive shell name? (one word)", "bash"], ["Which command prints the current working directory?", "pwd"], ["An absolute path always begins with which single character?", "/"], ["Which command lists directory contents? (short name)", "ls"], ["Which command prints file contents? (short name)", "cat"]]
EOF
compile_ask "$D" 'CN{lb_pwd_theory_ok}' 'bash|pwd|/|ls|cat' /tmp/qa_pwd-theory.json

# ---------- 07-absolute-path ----------
D="$CHALL/07-absolute-path"
mkdir -p "$D"
cat >"$D/README" <<'EOF'
Read /opt/lb/absolute/KEY using an absolute path. That string is the keyword.
EOF
compile_checker "$D" 'abs_path_ok' 'CN{lb_absolute_path}'
mkdir -p "$OPT/absolute"
printf '%s\n' 'abs_path_ok' >"$OPT/absolute/KEY"
ln -sfn /opt/lb/absolute "$D/absolute"

# ---------- 08-relative-climb ----------
D="$CHALL/08-relative-climb"
mkdir -p "$D"
cat >"$D/README" <<'EOF'
Start in nest/deep/here/. Reach the KEY two levels up without using /opt paths.
EOF
compile_checker "$D" 'up_two_found' 'CN{lb_relative_climb}'
mkdir -p "$D/nest/deep/here"
printf '%s\n' 'up_two_found' >"$D/nest/KEY"
echo 'climb up from here/' >"$D/nest/deep/here/START"

# ---------- 09-symlink-trap ----------
D="$CHALL/09-symlink-trap"
mkdir -p "$D"
cat >"$D/README" <<'EOF'
Enter maze/ (symlink). Find KEY at the real exit. Loops are decoys.
EOF
cat >"$D/HINT" <<'EOF'
Prefer absolute paths under /opt/lb/maze.
EOF
compile_checker "$D" 'symlink_exit_9' 'CN{lb_symlink_resolved}'
MAZE="$OPT/maze"
mkdir -p "$MAZE"/{a/b/c,x/y/z,trap/loop,real/exit}
ln -sfn "$MAZE/a/b" "$MAZE/start"
ln -sfn "$MAZE/trap/loop" "$MAZE/a/b/next"
ln -sfn "$MAZE/a" "$MAZE/trap/loop/back"
ln -sfn "$MAZE/real/exit" "$MAZE/x/y/gate"
echo 'cycle' >"$MAZE/trap/loop/hint.txt"
echo 'try x/y' >"$MAZE/a/b/c/clue.txt"
printf '%s\n' 'symlink_exit_9' >"$MAZE/real/exit/KEY"
ln -sfn /opt/lb/maze "$D/maze"

# ---------- 10-realpath-resolve ----------
D="$CHALL/10-realpath-resolve"
mkdir -p "$D"
cat >"$D/README" <<'EOF'
portal -> ... eventually a KEY. Resolve the canonical path.
EOF
compile_checker "$D" 'canon_path_10' 'CN{lb_realpath_wins}'
mkdir -p "$OPT/chain"/{a,b,c}
printf '%s\n' 'canon_path_10' >"$OPT/chain/c/KEY"
ln -sfn /opt/lb/chain/c "$OPT/chain/b/link"
ln -sfn /opt/lb/chain/b/link "$OPT/chain/a/portal"
ln -sfn /opt/lb/chain/a/portal "$D/portal"

# ---------- 11-find-by-name ----------
D="$CHALL/11-find-by-name"
mkdir -p "$D"
cat >"$D/README" <<'EOF'
Under tree/ there is exactly one prize.txt. Its contents are the keyword.
EOF
compile_checker "$D" 'named_prize' 'CN{lb_find_by_name}'
mkdir -p "$D/tree"/{a/b,c/d/e,f}
for i in $(seq 1 40); do echo decoy >"$D/tree/a/b/file_$i.txt"; done
printf '%s\n' 'named_prize' >"$D/tree/c/d/e/prize.txt"

# ---------- 12-find-by-content ----------
D="$CHALL/12-find-by-content"
mkdir -p "$D"
cat >"$D/README" <<'EOF'
Somewhere under dump/ a file contains NEEDLE=<keyword>. Find it.
EOF
compile_checker "$D" 'content_hit_12' 'CN{lb_find_grep_content}'
mkdir -p "$D/dump"/{1,2,3/deep}
for i in $(seq 1 60); do echo "id=$i" >"$D/dump/1/n_$i.txt"; done
echo 'NEEDLE=wrong' >"$D/dump/2/a.txt"
echo 'NEEDLE=content_hit_12' >"$D/dump/3/deep/hit.txt"

# ---------- 13-grep-one-file ----------
D="$CHALL/13-grep-one-file"
mkdir -p "$D"
cat >"$D/README" <<'EOF'
In access.log find the ERROR line that contains TOKEN=.
EOF
compile_checker "$D" 'GREP_HIT_13' 'CN{lb_grep_one}'
{
  for i in $(seq 1 80); do echo "INFO ok $i"; done
  echo 'ERROR guest TOKEN=nope'
  echo 'ERROR root TOKEN=GREP_HIT_13'
  echo 'WARN skip'
} >"$D/access.log"

# ---------- 14-grep-recursive ----------
D="$CHALL/14-grep-recursive"
mkdir -p "$D"
cat >"$D/README" <<'EOF'
Search conf/ for auth_token in a production-related file. Ignore *.bak.
EOF
compile_checker "$D" 'recurse_14_ok' 'CN{lb_grep_recursive}'
mkdir -p "$D/conf"/{dev,prod,stage}
echo 'auth_token=decoy' >"$D/conf/dev/app.cfg"
echo 'auth_token=recurse_14_ok' >"$D/conf/prod/app.cfg"
echo 'auth_token=stage' >"$D/conf/stage/app.cfg"
echo 'auth_token=recurse_14_ok' >"$D/conf/prod/app.cfg.bak"

# ---------- 15-find-size ----------
D="$CHALL/15-find-size"
mkdir -p "$D"
cat >"$D/README" <<'EOF'
Under sizes/ only one file is empty (0 bytes). That filename stem is not the keyword — read a sibling clue, or check: the keyword is inside marker.txt next to the empty file's directory. Actually: the empty file's name without extension IS wrong; read NOTES in that folder.
EOF
compile_checker "$D" 'size_matters_15' 'CN{lb_find_by_size}'
mkdir -p "$D/sizes"/{a,b,c}
echo filled >"$D/sizes/a/one.txt"
echo filledmore >"$D/sizes/b/two.txt"
: >"$D/sizes/c/empty.dat"
printf '%s\n' 'size_matters_15' >"$D/sizes/c/NOTES"

# ---------- 16-pipe-grep-wc ----------
D="$CHALL/16-pipe-grep-wc"
mkdir -p "$D"
cat >"$D/README" <<'EOF'
Count FAIL lines in events.log. Keyword: hits_are_<count>
EOF
compile_checker "$D" 'hits_are_17' 'CN{lb_pipe_grep_wc}'
{
  for i in $(seq 1 30); do echo "OK $i"; done
  for i in $(seq 1 17); do echo "FAIL item-$i"; done
  for i in $(seq 1 20); do echo "WARN $i"; done
} >"$D/events.log"

# ---------- 17-cut-fields ----------
D="$CHALL/17-cut-fields"
mkdir -p "$D"
cat >"$D/README" <<'EOF'
users.csv: find the row starting with ops and take field 3. That is the keyword.
EOF
compile_checker "$D" 'field_three_ok' 'CN{lb_cut_fields}'
cat >"$D/users.csv" <<'EOF'
name,role,token
guest,user,nope
ops,admin,field_three_ok
root,admin,decoy
EOF

# ---------- 18-sort-uniq ----------
D="$CHALL/18-sort-uniq"
mkdir -p "$D"
cat >"$D/README" <<'EOF'
votes.txt has many duplicates. The keyword appears exactly once.
EOF
cat >"$D/HINT" <<'EOF'
sort | uniq -c
EOF
compile_checker "$D" 'uniq_winner' 'CN{lb_sort_uniq}'
{
  for i in $(seq 1 20); do echo alpha; echo beta; done
  echo uniq_winner
  for i in $(seq 1 15); do echo gamma; done
} >"$D/votes.txt"

# ---------- 19-awk-select ----------
D="$CHALL/19-awk-select"
mkdir -p "$D"
cat >"$D/README" <<'EOF'
metrics.tsv columns: status bytes path. Sum bytes where status is ok. Keyword: awk_sum_<total>
EOF
compile_checker "$D" 'awk_sum_42' 'CN{lb_awk_power}'
cat >"$D/metrics.tsv" <<'EOF'
ok	10	/a
fail	99	/b
ok	12	/c
ok	20	/d
fail	5	/e
EOF

# ---------- 20-sed-extract ----------
D="$CHALL/20-sed-extract"
mkdir -p "$D"
cat >"$D/README" <<'EOF'
In messy.txt extract the code=... value (keyword).
EOF
compile_checker "$D" 'sed_code_20' 'CN{lb_sed_extract}'
echo 'prefix code=sed_code_20 suffix noise=1' >"$D/messy.txt"

# ---------- 21-whoami-id ----------
D="$CHALL/21-whoami-id"
mkdir -p "$D"
cat >"$D/README" <<'EOF'
Run whoami. Keyword format: i_am_<your-username>
EOF
compile_checker "$D" 'i_am_user' 'CN{lb_whoami}'
echo 'keyword format i_am_<whoami>' >"$D/NOTE"

# ---------- 22-chmod-own-file ----------
D="$CHALL/22-chmod-own-file"
mkdir -p "$D"
cat >"$D/README" <<'EOF'
locked.txt is unreadable. Fix its mode, read the keyword, run ./checker.
EOF
compile_checker "$D" 'perms_fixed_22' 'CN{lb_chmod_own}'
printf '%s\n' 'perms_fixed_22' >"$D/locked.txt"

# ---------- 23-perms-theory ----------
D="$CHALL/23-perms-theory"
mkdir -p "$D"
cat >"$D/README" <<'EOF'
Run ./ask. No sudo is required or allowed for these questions.
EOF
cat >/tmp/qa_perms-theory.json <<'EOF'
[["What does the x permission bit mean for a file? (one word: execute)", "execute"], ["Numeric mode for rw-r--r-- ? (three digits)", "644"], ["Command to change file mode bits? (short name)", "chmod"], ["Command to change file owner? (short name)", "chown"], ["Does a normal user get passwordless sudo ALL in this lab? (yes/no)", "no"]]
EOF
compile_ask "$D" 'CN{lb_perms_theory}' 'execute|644|chmod|chown|no' /tmp/qa_perms-theory.json

# ---------- 24-find-writable ----------
D="$CHALL/24-find-writable"
mkdir -p "$D"
cat >"$D/README" <<'EOF'
Under cage/ one file is world-writable. Its contents are the keyword.
EOF
compile_checker "$D" 'writable_spot' 'CN{lb_find_writable}'
mkdir -p "$D/cage"/{1,2,3}
echo no >"$D/cage/1/a.txt"; chmod 644 "$D/cage/1/a.txt"
echo no >"$D/cage/2/b.txt"; chmod 600 "$D/cage/2/b.txt"
printf '%s\n' 'writable_spot' >"$D/cage/3/open.txt"; chmod 666 "$D/cage/3/open.txt"

# ---------- 25-id-groups ----------
D="$CHALL/25-id-groups"
mkdir -p "$D"
cat >"$D/README" <<'EOF'
secret.grp is group-readable by labusers. You should be in that group. Read it.
EOF
compile_checker "$D" 'group_labusers' 'CN{lb_id_groups}'
printf '%s\n' 'group_labusers' >"$D/secret.grp"

# ---------- 26-env-leak ----------
D="$CHALL/26-env-leak"
mkdir -p "$D"
cat >"$D/README" <<'EOF'
This station's shell profile exports LB_KEYWORD. Use it with ./checker.
EOF
compile_checker "$D" 'ENV_TOKEN_26' 'CN{lb_env_leak}'
echo 'LB_KEYWORD is exported in your ~/.bashrc — open a new shell or source it.' >"$D/NOTE"

# ---------- 27-path-theory ----------
D="$CHALL/27-path-theory"
mkdir -p "$D"
cat >"$D/README" <<'EOF'
Run ./ask for environment and redirection questions.
EOF
cat >/tmp/qa_path-theory.json <<'EOF'
[["Which variable lists directories searched for commands? (name only)", "path"], ["Which command prints the environment? (short name)", "env"], ["Keyword to place a variable into the environment for child processes?", "export"], ["Redirect stdout and stderr together with which operator? (like digit>&digit)", "2>&1"], ["File that often holds per-user interactive bash settings? (basename only)", ".bashrc"]]
EOF
compile_ask "$D" 'CN{lb_path_theory}' 'path|env|export|2>&1|.bashrc' /tmp/qa_path-theory.json

# ---------- 28-bashrc-secret ----------
D="$CHALL/28-bashrc-secret"
mkdir -p "$D"
cat >"$D/README" <<'EOF'
Read the local .bashrc_local in this folder.
EOF
compile_checker "$D" 'alias_hides_28' 'CN{lb_bashrc_secret}'
printf 'KEYWORD=%s\n' 'alias_hides_28' >"$D/.bashrc_local"
echo 'source the local rc or just read it' >"$D/NOTE"

# ---------- 29-man-theory ----------
D="$CHALL/29-man-theory"
mkdir -p "$D"
cat >"$D/README" <<'EOF'
Run ./ask. man sections matter.
EOF
cat >/tmp/qa_man-theory.json <<'EOF'
[["Which man section is for user commands? (number)", "1"], ["Which man section is for system admin commands? (number)", "8"], ["Command to read the manual page for ls?", "man ls"], ["Option often used with commands to show help briefly? (like --help)", "--help"], ["Command that searches man pages descriptions? (short name)", "apropos"]]
EOF
compile_ask "$D" 'CN{lb_man_theory}' '1|8|man ls|--help|apropos' /tmp/qa_man-theory.json

# ---------- 30-tar-extract ----------
D="$CHALL/30-tar-extract"
mkdir -p "$D"
cat >"$D/README" <<'EOF'
Extract box.tar here, then read what you find. Use ./checker.
EOF
compile_checker "$D" 'tar_payload_30' 'CN{lb_tar_extract}'
mkdir -p "$D/.pack"
printf '%s\n' 'tar_payload_30' >"$D/.pack/KEY"
tar -cf "$D/box.tar" -C "$D/.pack" KEY
rm -rf "$D/.pack"

# ---------- 31-gzip-peek ----------
D="$CHALL/31-gzip-peek"
mkdir -p "$D"
cat >"$D/README" <<'EOF'
secret.txt.gz holds the keyword as plain text once decompressed.
EOF
compile_checker "$D" 'gzip_clear_31' 'CN{lb_gzip_peek}'
printf '%s\n' 'gzip_clear_31' >"$D/secret.txt"
gzip -f "$D/secret.txt"

# ---------- 32-nested-tar ----------
D="$CHALL/32-nested-tar"
mkdir -p "$D"
cat >"$D/README" <<'EOF'
outer.tar contains another archive. Keep going until KEY appears.
EOF
compile_checker "$D" 'nested_core_32' 'CN{lb_nested_tar}'
mkdir -p "$D/.n/inner"
printf '%s\n' 'nested_core_32' >"$D/.n/inner/KEY"
tar -czf "$D/.n/inner.tar.gz" -C "$D/.n/inner" KEY
rm -rf "$D/.n/inner"
tar -cf "$D/outer.tar" -C "$D/.n" inner.tar.gz
rm -rf "$D/.n"

# ---------- 33-base64-note ----------
D="$CHALL/33-base64-note"
mkdir -p "$D"
cat >"$D/README" <<'EOF'
Decode encoded.txt (base64). The result is the keyword.
EOF
compile_checker "$D" 'b64_plain_33' 'CN{lb_base64}'
printf '%s' 'b64_plain_33' | base64 >"$D/encoded.txt"

# ---------- 34-xxd-hex ----------
D="$CHALL/34-xxd-hex"
mkdir -p "$D"
cat >"$D/README" <<'EOF'
blob.hex is an xxd-style dump. Recover the ASCII keyword.
EOF
compile_checker "$D" 'hex_speak_34' 'CN{lb_xxd_hex}'
printf '%s' 'hex_speak_34' | xxd >"$D/blob.hex"

# ---------- 35-ps-clue ----------
D="$CHALL/35-ps-clue"
mkdir -p "$D"
cat >"$D/README" <<'EOF'
A process named lb-helper is running. Its args include the keyword.
EOF
compile_checker "$D" 'proc_clue_35' 'CN{lb_ps_clue}'
echo 'Inspect running processes for lb-helper.' >"$D/NOTE"

# ---------- 36-hosts-lookup ----------
D="$CHALL/36-hosts-lookup"
mkdir -p "$D"
cat >"$D/README" <<'EOF'
Read hosts.snippet for lab-flag.local — the comment holds KEYWORD=.
EOF
compile_checker "$D" 'labhost_ok' 'CN{lb_hosts_file}'
echo '127.0.0.1 lab-flag.local # KEYWORD=labhost_ok' >"$D/hosts.snippet"
echo 'This lab keeps a hosts snippet here instead of editing /etc/hosts.' >"$D/NOTE"

# ---------- 37-du-biggest ----------
D="$CHALL/37-du-biggest"
mkdir -p "$D"
cat >"$D/README" <<'EOF'
Under pile/ one file is much larger. Read its first line.
EOF
cat >"$D/HINT" <<'EOF'
du -a | sort -n
EOF
compile_checker "$D" 'biggest_is_core' 'CN{lb_du_biggest}'
mkdir -p "$D/pile"
echo small >"$D/pile/a.txt"
echo small >"$D/pile/b.txt"
{ echo 'biggest_is_core'; dd if=/dev/zero bs=1024 count=50 2>/dev/null; } >"$D/pile/core.dat"

# ---------- 38-strings-bin ----------
D="$CHALL/38-strings-bin"
mkdir -p "$D"
cat >"$D/README" <<'EOF'
blob.bin looks useless. Extract printable strings; find KEYWORD=.
EOF
compile_checker "$D" 'string_inside_38' 'CN{lb_strings_bin}'
python3 -c "import pathlib; p=pathlib.Path('$D/blob.bin'); p.write_bytes(b'x'*200 + b'KEYWORD=string_inside_38' + b'y'*200)"

# ---------- 39-cron-clue ----------
D="$CHALL/39-cron-clue"
mkdir -p "$D"
cat >"$D/README" <<'EOF'
Read cron/jobs.txt — a commented line hides KEYWORD=.
EOF
compile_checker "$D" 'cron_job_39' 'CN{lb_cron_clue}'
mkdir -p "$D/cron"
printf '# nightly\n# KEYWORD=cron_job_39\n0 3 * * * /usr/bin/true\n' >"$D/cron/jobs.txt"

# ---------- 40-multi-pipe ----------
D="$CHALL/40-multi-pipe"
mkdir -p "$D"
cat >"$D/README" <<'EOF'
Filter service.log: ERROR lines for user ops; extract TOKEN= value.
EOF
compile_checker "$D" 'OPS_SIGNAL_40' 'CN{lb_multi_pipe}'
mkdir -p /var/log/lb
{
  for i in $(seq 1 80); do echo "INFO guest hb-$i"; done
  echo 'ERROR root FAIL_00'
  echo 'ERROR ops FAIL_22'
  echo 'ERROR ops TOKEN=OPS_SIGNAL_40 detail=auth'
  echo 'ERROR ops FAIL_33'
  for i in $(seq 1 40); do echo "DEBUG ops noise-$i"; done
} >/var/log/lb/service.log
ln -sfn /var/log/lb "$D/logs"
chmod -R a+rX /var/log/lb

# ---------- 41-needle-maze ----------
D="$CHALL/41-needle-maze"
mkdir -p "$D"
cat >"$D/README" <<'EOF'
Search /opt/lb/web. Prefer prod *.cfg; ignore .git and backup/.
EOF
compile_checker "$D" 'needle_in_hay_41' 'CN{lb_needle_maze}'
WEB="$OPT/web"
mkdir -p "$WEB"/{assets,vendor,backup,tmp,.git/objects,assets/deep/nested/config}
for i in $(seq 1 80); do echo ok >"$WEB/assets/item_$i.txt"; done
echo 'needle_in_hay_00 wrong' >"$WEB/backup/old.txt"
echo 'auth_token=decoy' >"$WEB/assets/deep/nested/config/dev.cfg"
echo 'auth_token=needle_in_hay_41' >"$WEB/assets/deep/nested/config/app.cfg"
echo 'prod endpoint' >>"$WEB/assets/deep/nested/config/app.cfg"
ln -sfn /opt/lb/web "$D/web"

# ---------- 42-finals-theory ----------
D="$CHALL/42-finals-theory"
mkdir -p "$D"
cat >"$D/README" <<'EOF'
Capstone quiz. Run ./ask.
EOF
cat >/tmp/qa_finals-theory.json <<'EOF'
[["Symbol that pipes stdout of one command into stdin of the next?", "|"], ["Command to find files by name under a directory tree? (short name)", "find"], ["Command to search inside file contents? (short name)", "grep"], ["Numeric mode that makes a file rwx for owner only? (three digits)", "700"], ["Should challenge checkers be world-readable shell scripts? (yes/no)", "no"]]
EOF
compile_ask "$D" 'CN{lb_finals_theory}' '||find|grep|700|no' /tmp/qa_finals-theory.json

# ---------- MOTD / home ----------
cat >"$USER_HOME/START_HERE" <<'EOF'
Linux Basics I — lab map

cd ~/challenges
ls
cat 01-hidden-dotfiles/README

Practical stations: find a keyword, then run ./checker '<keyword>'
Theory stations: run ./ask and type answers

Checkers and ask binaries are execute-only (not readable).
You do NOT have unrestricted sudo in this lab.
EOF

# helper process for station 35
cat >/usr/local/bin/lb-helper <<'EOF'
#!/bin/bash
# decoy sleeper; keyword in argv from systemd-style launch
sleep infinity
EOF
chmod 755 /usr/local/bin/lb-helper
# started later via entrypoint snippet — bake a supervisord-less nohup in sshrc
cat >/etc/ssh/sshrc <<'EOF'
#!/bin/bash
pgrep -f 'lb-helper proc_clue_35' >/dev/null 2>&1 || \
  nohup /usr/local/bin/lb-helper proc_clue_35 >/dev/null 2>&1 &
EOF
chmod 755 /etc/ssh/sshrc

# station 26: drop env into a sourced file students can discover
# (export in a file they read / source — also put in their bashrc)
echo 'export LB_KEYWORD=ENV_TOKEN_26' >> /home/user/.bashrc

chown -R user:user "$USER_HOME"
# re-assert execute-only on all checkers/ask after chown -R
find "$CHALL" -type f \( -name checker -o -name ask \) -exec chown root:root {} \; -exec chmod 111 {} \;

chown -R root:root "$OPT"
chmod -R a+rX "$OPT"
# group secret
if [[ -f $CHALL/25-id-groups/secret.grp ]]; then
  chown root:labusers "$CHALL/25-id-groups/secret.grp"
  chmod 640 "$CHALL/25-id-groups/secret.grp"
fi
# locked file owned by user mode 000
if [[ -f $CHALL/22-chmod-own-file/locked.txt ]]; then
  chown user:user "$CHALL/22-chmod-own-file/locked.txt"
  chmod 000 "$CHALL/22-chmod-own-file/locked.txt"
fi

echo "setup complete"
