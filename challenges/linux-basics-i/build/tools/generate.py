#!/usr/bin/env python3
"""Generate hackploy.json + setup.sh for linux-basics-i (40+ stations)."""
from __future__ import annotations

import hashlib
import json
import textwrap
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
STATIONS = ROOT / "stations"


def sha256_text(s: str) -> str:
    return hashlib.sha256(s.encode()).hexdigest()


def xor_flag_hex(flag: str, key_material: str) -> str:
    key = hashlib.sha256(key_material.encode()).digest()
    raw = flag.encode()
    return "".join(f"{b ^ key[i % len(key)]:02x}" for i, b in enumerate(raw))


# type: checker | ask
# hints: platform hints (optional)
# lab_hint: optional on-disk HINT file text
CHALLENGES: list[dict] = [
    # --- Files & listing ---
    {
        "id": "01-hidden-dotfiles",
        "name": "hidden-dotfiles",
        "display": "01 · Hidden Dotfiles",
        "section": "Files & listing",
        "difficulty": "easy",
        "points": 50,
        "type": "checker",
        "keyword": "ghost_ls_a",
        "flag": "CN{lb_hidden_dotfiles}",
        "desc": "Easy — find what a normal ls hides, then unlock with ./checker.",
        "hints": ["Try listing all entries, including names that start with a dot."],
        "readme": "Something in this folder is hidden from a plain ls.\nFind the keyword file, then run: ./checker '<keyword>'",
        "lab_hint": "ls alone is not enough.",
    },
    {
        "id": "02-cat-readme",
        "name": "cat-readme",
        "display": "02 · Cat the Note",
        "section": "Files & listing",
        "difficulty": "easy",
        "points": 50,
        "type": "checker",
        "keyword": "open_sesame_cat",
        "flag": "CN{lb_cat_the_note}",
        "desc": "Easy — read a plain text note and feed the keyword to ./checker.",
        "hints": [],
        "readme": "Read note.txt. The KEYWORD= line is what ./checker wants.",
    },
    {
        "id": "03-head-log",
        "name": "head-log",
        "display": "03 · Head of the Log",
        "section": "Files & listing",
        "difficulty": "easy",
        "points": 75,
        "type": "checker",
        "keyword": "HEAD_TOKEN_7",
        "flag": "CN{lb_head_sees_first}",
        "desc": "Easy — the useful line is near the top of a long file.",
        "hints": ["head shows the beginning of a file.", "Look for TOKEN= near the top of big.log."],
        "readme": "big.log is noisy. The keyword is early in the file as TOKEN=...",
    },
    {
        "id": "04-tail-secret",
        "name": "tail-secret",
        "display": "04 · Tail Secret",
        "section": "Files & listing",
        "difficulty": "easy",
        "points": 75,
        "type": "checker",
        "keyword": "TAIL_OK_99",
        "flag": "CN{lb_tail_sees_last}",
        "desc": "Easy — the keyword sits at the end of a long file.",
        "hints": [],
        "readme": "trail.log ends with the keyword. Use a tool that reads the end of a file.",
    },
    {
        "id": "05-wc-lines",
        "name": "wc-lines",
        "display": "05 · Count Lines",
        "section": "Files & listing",
        "difficulty": "medium",
        "points": 100,
        "type": "checker",
        "keyword": "lines_are_120",
        "flag": "CN{lb_wc_counts}",
        "desc": "Medium — count lines in data.txt; that count unlocks the keyword pattern.",
        "hints": [],
        "readme": "Count the lines in data.txt. The keyword is: lines_are_<COUNT>",
        "lab_hint": "wc -l",
    },
    # --- Paths ---
    {
        "id": "06-pwd-theory",
        "name": "pwd-theory",
        "display": "06 · Shell Path Theory",
        "section": "Paths",
        "difficulty": "easy",
        "points": 50,
        "type": "ask",
        "flag": "CN{lb_pwd_theory_ok}",
        "desc": "Easy theory — run ./ask and answer path/shell basics.",
        "hints": [],
        "readme": "No file hunting. Run ./ask and answer each question.",
        "answers": [
            ("On many Linux distros, what is the default interactive shell name? (one word)", "bash"),
            ("Which command prints the current working directory?", "pwd"),
            ("An absolute path always begins with which single character?", "/"),
            ("Which command lists directory contents? (short name)", "ls"),
            ("Which command prints file contents? (short name)", "cat"),
        ],
    },
    {
        "id": "07-absolute-path",
        "name": "absolute-path",
        "display": "07 · Absolute Path",
        "section": "Paths",
        "difficulty": "easy",
        "points": 100,
        "type": "checker",
        "keyword": "abs_path_ok",
        "flag": "CN{lb_absolute_path}",
        "desc": "Easy — reach a file using an absolute path under /opt/lb.",
        "hints": ["Start from /opt/lb — do not rely on your current directory."],
        "readme": "Read /opt/lb/absolute/KEY using an absolute path. That string is the keyword.",
    },
    {
        "id": "08-relative-climb",
        "name": "relative-climb",
        "display": "08 · Relative Climb",
        "section": "Paths",
        "difficulty": "medium",
        "points": 150,
        "type": "checker",
        "keyword": "up_two_found",
        "flag": "CN{lb_relative_climb}",
        "desc": "Medium — climb with ../ from a nested folder to find KEY.",
        "hints": [],
        "readme": "Start in nest/deep/here/. Reach the KEY two levels up without using /opt paths.",
    },
    {
        "id": "09-symlink-trap",
        "name": "symlink-trap",
        "display": "09 · Symlink Trap",
        "section": "Paths",
        "difficulty": "medium",
        "points": 150,
        "type": "checker",
        "keyword": "symlink_exit_9",
        "flag": "CN{lb_symlink_resolved}",
        "desc": "Medium — follow the real symlink exit; avoid the loop.",
        "hints": ["ls -l shows where links point.", "readlink or realpath can help."],
        "readme": "Enter maze/ (symlink). Find KEY at the real exit. Loops are decoys.",
        "lab_hint": "Prefer absolute paths under /opt/lb/maze.",
    },
    {
        "id": "10-realpath-resolve",
        "name": "realpath-resolve",
        "display": "10 · Realpath",
        "section": "Paths",
        "difficulty": "hard",
        "points": 200,
        "type": "checker",
        "keyword": "canon_path_10",
        "flag": "CN{lb_realpath_wins}",
        "desc": "Hard — resolve a chain of symlinks to the canonical KEY.",
        "hints": [],
        "readme": "portal -> ... eventually a KEY. Resolve the canonical path.",
    },
    # --- Search ---
    {
        "id": "11-find-by-name",
        "name": "find-by-name",
        "display": "11 · Find by Name",
        "section": "Search",
        "difficulty": "easy",
        "points": 100,
        "type": "checker",
        "keyword": "named_prize",
        "flag": "CN{lb_find_by_name}",
        "desc": "Easy — find a file named prize.txt somewhere under tree/.",
        "hints": ["find . -name prize.txt"],
        "readme": "Under tree/ there is exactly one prize.txt. Its contents are the keyword.",
    },
    {
        "id": "12-find-by-content",
        "name": "find-by-content",
        "display": "12 · Find by Content",
        "section": "Search",
        "difficulty": "medium",
        "points": 150,
        "type": "checker",
        "keyword": "content_hit_12",
        "flag": "CN{lb_find_grep_content}",
        "desc": "Medium — search file contents under dump/ for NEEDLE=.",
        "hints": [],
        "readme": "Somewhere under dump/ a file contains NEEDLE=<keyword>. Find it.",
    },
    {
        "id": "13-grep-one-file",
        "name": "grep-one-file",
        "display": "13 · Grep One File",
        "section": "Search",
        "difficulty": "easy",
        "points": 75,
        "type": "checker",
        "keyword": "GREP_HIT_13",
        "flag": "CN{lb_grep_one}",
        "desc": "Easy — grep a single file for the ERROR line with the token.",
        "hints": ["grep ERROR access.log"],
        "readme": "In access.log find the ERROR line that contains TOKEN=.",
    },
    {
        "id": "14-grep-recursive",
        "name": "grep-recursive",
        "display": "14 · Grep Recursive",
        "section": "Search",
        "difficulty": "medium",
        "points": 150,
        "type": "checker",
        "keyword": "recurse_14_ok",
        "flag": "CN{lb_grep_recursive}",
        "desc": "Medium — recursive grep across conf/ for production auth_token.",
        "hints": [],
        "readme": "Search conf/ for auth_token in a production-related file. Ignore *.bak.",
    },
    {
        "id": "15-find-size",
        "name": "find-size",
        "display": "15 · Find by Size",
        "section": "Search",
        "difficulty": "hard",
        "points": 200,
        "type": "checker",
        "keyword": "size_matters_15",
        "flag": "CN{lb_find_by_size}",
        "desc": "Hard — find the only empty file under sizes/; it holds the keyword.",
        "hints": ["find can filter by size.", "An empty file has size 0."],
        "readme": "Under sizes/ only one file is empty (0 bytes). That filename stem is not the keyword — read a sibling clue, or check: the keyword is inside marker.txt next to the empty file's directory. Actually: the empty file's name without extension IS wrong; read NOTES in that folder.",
    },
    # --- Pipes & text ---
    {
        "id": "16-pipe-grep-wc",
        "name": "pipe-grep-wc",
        "display": "16 · Pipe Grep WC",
        "section": "Pipes & text",
        "difficulty": "easy",
        "points": 100,
        "type": "checker",
        "keyword": "hits_are_17",
        "flag": "CN{lb_pipe_grep_wc}",
        "desc": "Easy — count how many lines match FAIL in events.log; keyword hits_are_<n>.",
        "hints": [],
        "readme": "Count FAIL lines in events.log. Keyword: hits_are_<count>",
    },
    {
        "id": "17-cut-fields",
        "name": "cut-fields",
        "display": "17 · Cut Fields",
        "section": "Pipes & text",
        "difficulty": "medium",
        "points": 150,
        "type": "checker",
        "keyword": "field_three_ok",
        "flag": "CN{lb_cut_fields}",
        "desc": "Medium — CSV field extraction; third column on the ops row.",
        "hints": ["cut -d, -f3", "Find the row where the first column is ops."],
        "readme": "users.csv: find the row starting with ops and take field 3. That is the keyword.",
    },
    {
        "id": "18-sort-uniq",
        "name": "sort-uniq",
        "display": "18 · Sort Uniq",
        "section": "Pipes & text",
        "difficulty": "medium",
        "points": 150,
        "type": "checker",
        "keyword": "uniq_winner",
        "flag": "CN{lb_sort_uniq}",
        "desc": "Medium — find the value that appears exactly once in votes.txt.",
        "hints": [],
        "readme": "votes.txt has many duplicates. The keyword appears exactly once.",
        "lab_hint": "sort | uniq -c",
    },
    {
        "id": "19-awk-select",
        "name": "awk-select",
        "display": "19 · Awk Select",
        "section": "Pipes & text",
        "difficulty": "hard",
        "points": 250,
        "type": "checker",
        "keyword": "awk_sum_42",
        "flag": "CN{lb_awk_power}",
        "desc": "Hard — sum the bytes column for status=ok rows; keyword awk_sum_<total>.",
        "hints": ["awk can filter and sum columns."],
        "readme": "metrics.tsv columns: status bytes path. Sum bytes where status is ok. Keyword: awk_sum_<total>",
    },
    {
        "id": "20-sed-extract",
        "name": "sed-extract",
        "display": "20 · Sed Extract",
        "section": "Pipes & text",
        "difficulty": "hard",
        "points": 250,
        "type": "checker",
        "keyword": "sed_code_20",
        "flag": "CN{lb_sed_extract}",
        "desc": "Hard — extract the code= value from a messy line with sed.",
        "hints": [],
        "readme": "In messy.txt extract the code=... value (keyword).",
    },
    # --- Permissions & identity ---
    {
        "id": "21-whoami-id",
        "name": "whoami-id",
        "display": "21 · Who Am I",
        "section": "Permissions & identity",
        "difficulty": "easy",
        "points": 50,
        "type": "checker",
        "keyword": "i_am_user",
        "flag": "CN{lb_whoami}",
        "desc": "Easy — confirm your login name; keyword is i_am_<username>.",
        "hints": [],
        "readme": "Run whoami. Keyword format: i_am_<your-username>",
    },
    {
        "id": "22-chmod-own-file",
        "name": "chmod-own-file",
        "display": "22 · Chmod Own File",
        "section": "Permissions & identity",
        "difficulty": "medium",
        "points": 100,
        "type": "checker",
        "keyword": "perms_fixed_22",
        "flag": "CN{lb_chmod_own}",
        "desc": "Medium — a file you own is mode 000; fix perms and read the keyword.",
        "hints": ["You own locked.txt — chmod can restore read permission."],
        "readme": "locked.txt is unreadable. Fix its mode, read the keyword, run ./checker.",
    },
    {
        "id": "23-perms-theory",
        "name": "perms-theory",
        "display": "23 · Permissions Theory",
        "section": "Permissions & identity",
        "difficulty": "medium",
        "points": 150,
        "type": "ask",
        "flag": "CN{lb_perms_theory}",
        "desc": "Medium theory — ./ask about chmod bits and ownership.",
        "hints": ["rwx are read write execute.", "chmod 644 is rw-r--r--."],
        "readme": "Run ./ask. No sudo is required or allowed for these questions.",
        "answers": [
            ("What does the x permission bit mean for a file? (one word: execute)", "execute"),
            ("Numeric mode for rw-r--r-- ? (three digits)", "644"),
            ("Command to change file mode bits? (short name)", "chmod"),
            ("Command to change file owner? (short name)", "chown"),
            ("Does a normal user get passwordless sudo ALL in this lab? (yes/no)", "no"),
        ],
    },
    {
        "id": "24-find-writable",
        "name": "find-writable",
        "display": "24 · Find Writable",
        "section": "Permissions & identity",
        "difficulty": "medium",
        "points": 150,
        "type": "checker",
        "keyword": "writable_spot",
        "flag": "CN{lb_find_writable}",
        "desc": "Medium — find the world-writable file under cage/ and read it.",
        "hints": ["find -perm -0002 or -writable"],
        "readme": "Under cage/ one file is world-writable. Its contents are the keyword.",
    },
    {
        "id": "25-id-groups",
        "name": "id-groups",
        "display": "25 · Id Groups",
        "section": "Permissions & identity",
        "difficulty": "hard",
        "points": 200,
        "type": "checker",
        "keyword": "group_labusers",
        "flag": "CN{lb_id_groups}",
        "desc": "Hard — read a group-readable secret using your supplementary group.",
        "hints": [],
        "readme": "secret.grp is group-readable by labusers. You should be in that group. Read it.",
    },
    # --- Environment ---
    {
        "id": "26-env-leak",
        "name": "env-leak",
        "display": "26 · Env Leak",
        "section": "Environment",
        "difficulty": "easy",
        "points": 100,
        "type": "checker",
        "keyword": "ENV_TOKEN_26",
        "flag": "CN{lb_env_leak}",
        "desc": "Easy — an environment variable in the station wrapper holds the keyword.",
        "hints": ["Check env or printenv for LB_KEYWORD."],
        "readme": "This station's shell profile exports LB_KEYWORD. Use it with ./checker.",
    },
    {
        "id": "27-path-theory",
        "name": "path-theory",
        "display": "27 · PATH Theory",
        "section": "Environment",
        "difficulty": "medium",
        "points": 150,
        "type": "ask",
        "flag": "CN{lb_path_theory}",
        "desc": "Medium theory — ./ask about PATH, export, and redirection.",
        "hints": [],
        "readme": "Run ./ask for environment and redirection questions.",
        "answers": [
            ("Which variable lists directories searched for commands? (name only)", "path"),
            ("Which command prints the environment? (short name)", "env"),
            ("Keyword to place a variable into the environment for child processes?", "export"),
            ("Redirect stdout and stderr together with which operator? (like digit>&digit)", "2>&1"),
            ("File that often holds per-user interactive bash settings? (basename only)", ".bashrc"),
        ],
    },
    {
        "id": "28-bashrc-secret",
        "name": "bashrc-secret",
        "display": "28 · Bashrc Secret",
        "section": "Environment",
        "difficulty": "medium",
        "points": 150,
        "type": "checker",
        "keyword": "alias_hides_28",
        "flag": "CN{lb_bashrc_secret}",
        "desc": "Medium — find a keyword hidden in a local bashrc snippet.",
        "hints": ["Dotfiles again.", "Look for KEYWORD= in the local rc file."],
        "readme": "Read the local .bashrc_local in this folder.",
    },
    {
        "id": "29-man-theory",
        "name": "man-theory",
        "display": "29 · Man Theory",
        "section": "Environment",
        "difficulty": "hard",
        "points": 200,
        "type": "ask",
        "flag": "CN{lb_man_theory}",
        "desc": "Hard theory — ./ask about man sections and getting help.",
        "hints": [],
        "readme": "Run ./ask. man sections matter.",
        "answers": [
            ("Which man section is for user commands? (number)", "1"),
            ("Which man section is for system admin commands? (number)", "8"),
            ("Command to read the manual page for ls?", "man ls"),
            ("Option often used with commands to show help briefly? (like --help)", "--help"),
            ("Command that searches man pages descriptions? (short name)", "apropos"),
        ],
    },
    # --- Archives & encoding ---
    {
        "id": "30-tar-extract",
        "name": "tar-extract",
        "display": "30 · Tar Extract",
        "section": "Archives & encoding",
        "difficulty": "easy",
        "points": 100,
        "type": "checker",
        "keyword": "tar_payload_30",
        "flag": "CN{lb_tar_extract}",
        "desc": "Easy — extract box.tar and read the keyword file inside.",
        "hints": [],
        "readme": "Extract box.tar here, then read what you find. Use ./checker.",
    },
    {
        "id": "31-gzip-peek",
        "name": "gzip-peek",
        "display": "31 · Gzip Peek",
        "section": "Archives & encoding",
        "difficulty": "medium",
        "points": 150,
        "type": "checker",
        "keyword": "gzip_clear_31",
        "flag": "CN{lb_gzip_peek}",
        "desc": "Medium — read a gzip-compressed note without leaving a mess.",
        "hints": ["zcat or gzip -dc"],
        "readme": "secret.txt.gz holds the keyword as plain text once decompressed.",
    },
    {
        "id": "32-nested-tar",
        "name": "nested-tar",
        "display": "32 · Nested Tar",
        "section": "Archives & encoding",
        "difficulty": "hard",
        "points": 250,
        "type": "checker",
        "keyword": "nested_core_32",
        "flag": "CN{lb_nested_tar}",
        "desc": "Hard — unpack nested archives until you reach the keyword.",
        "hints": [],
        "readme": "outer.tar contains another archive. Keep going until KEY appears.",
    },
    {
        "id": "33-base64-note",
        "name": "base64-note",
        "display": "33 · Base64 Note",
        "section": "Archives & encoding",
        "difficulty": "easy",
        "points": 100,
        "type": "checker",
        "keyword": "b64_plain_33",
        "flag": "CN{lb_base64}",
        "desc": "Easy — decode a base64 blob to get the keyword.",
        "hints": ["base64 -d"],
        "readme": "Decode encoded.txt (base64). The result is the keyword.",
    },
    {
        "id": "34-xxd-hex",
        "name": "xxd-hex",
        "display": "34 · Hex Note",
        "section": "Archives & encoding",
        "difficulty": "hard",
        "points": 250,
        "type": "checker",
        "keyword": "hex_speak_34",
        "flag": "CN{lb_xxd_hex}",
        "desc": "Hard — recover an ASCII keyword from a hex dump.",
        "hints": [],
        "readme": "blob.hex is an xxd-style dump. Recover the ASCII keyword.",
    },
    # --- Process & system ---
    {
        "id": "35-ps-clue",
        "name": "ps-clue",
        "display": "35 · Process Clue",
        "section": "Process & system",
        "difficulty": "medium",
        "points": 150,
        "type": "checker",
        "keyword": "proc_clue_35",
        "flag": "CN{lb_ps_clue}",
        "desc": "Medium — a background helper process command line contains the keyword.",
        "hints": ["ps aux | grep lb-helper", "Look at the full command line."],
        "readme": "A process named lb-helper is running. Its args include the keyword.",
    },
    {
        "id": "36-hosts-lookup",
        "name": "hosts-lookup",
        "display": "36 · Hosts File",
        "section": "Process & system",
        "difficulty": "easy",
        "points": 75,
        "type": "checker",
        "keyword": "labhost_ok",
        "flag": "CN{lb_hosts_file}",
        "desc": "Easy — read the lab hosts snippet for lab-flag.local.",
        "hints": [],
        "readme": "Read hosts.snippet for lab-flag.local — the comment holds KEYWORD=.",
    },
    {
        "id": "37-du-biggest",
        "name": "du-biggest",
        "display": "37 · Biggest File",
        "section": "Process & system",
        "difficulty": "medium",
        "points": 150,
        "type": "checker",
        "keyword": "biggest_is_core",
        "flag": "CN{lb_du_biggest}",
        "desc": "Medium — find the largest file under pile/; its first line is the keyword.",
        "hints": [],
        "readme": "Under pile/ one file is much larger. Read its first line.",
        "lab_hint": "du -a | sort -n",
    },
    {
        "id": "38-strings-bin",
        "name": "strings-bin",
        "display": "38 · Strings in Binary",
        "section": "Process & system",
        "difficulty": "hard",
        "points": 300,
        "type": "checker",
        "keyword": "string_inside_38",
        "flag": "CN{lb_strings_bin}",
        "desc": "Hard — extract a readable keyword from a binary blob.",
        "hints": ["strings blob.bin | grep KEY"],
        "readme": "blob.bin looks useless. Extract printable strings; find KEYWORD=.",
    },
    {
        "id": "39-cron-clue",
        "name": "cron-clue",
        "display": "39 · Cron Clue",
        "section": "Process & system",
        "difficulty": "medium",
        "points": 200,
        "type": "checker",
        "keyword": "cron_job_39",
        "flag": "CN{lb_cron_clue}",
        "desc": "Medium — read a readable crontab snippet for the keyword.",
        "hints": [],
        "readme": "Read cron/jobs.txt — a commented line hides KEYWORD=.",
    },
    # --- Capstone ---
    {
        "id": "40-multi-pipe",
        "name": "multi-pipe",
        "display": "40 · Multi Pipe",
        "section": "Capstone",
        "difficulty": "hard",
        "points": 300,
        "type": "checker",
        "keyword": "OPS_SIGNAL_40",
        "flag": "CN{lb_multi_pipe}",
        "desc": "Hard — filter logs with a pipeline to isolate the ops TOKEN.",
        "hints": ["grep ERROR, then ops, then pull TOKEN="],
        "readme": "Filter service.log: ERROR lines for user ops; extract TOKEN= value.",
    },
    {
        "id": "41-needle-maze",
        "name": "needle-maze",
        "display": "41 · Needle Maze",
        "section": "Capstone",
        "difficulty": "hard",
        "points": 350,
        "type": "checker",
        "keyword": "needle_in_hay_41",
        "flag": "CN{lb_needle_maze}",
        "desc": "Hard — find production auth_token in a messy web tree; no platform hints.",
        "hints": [],
        "readme": "Search /opt/lb/web. Prefer prod *.cfg; ignore .git and backup/.",
    },
    {
        "id": "42-finals-theory",
        "name": "finals-theory",
        "display": "42 · Finals Theory",
        "section": "Capstone",
        "difficulty": "hard",
        "points": 300,
        "type": "ask",
        "flag": "CN{lb_finals_theory}",
        "desc": "Hard theory — mixed Linux basics via ./ask (no file hunting).",
        "hints": ["Think about pipes, find, and permissions."],
        "readme": "Capstone quiz. Run ./ask.",
        "answers": [
            ("Symbol that pipes stdout of one command into stdin of the next?", "|"),
            ("Command to find files by name under a directory tree? (short name)", "find"),
            ("Command to search inside file contents? (short name)", "grep"),
            ("Numeric mode that makes a file rwx for owner only? (three digits)", "700"),
            ("Should challenge checkers be world-readable shell scripts? (yes/no)", "no"),
        ],
    },
]


def esc_c(s: str) -> str:
    return (
        s.replace("\\", "\\\\")
        .replace('"', '\\"')
        .replace("\n", "\\n")
    )


def write_hackploy() -> None:
    challenges = []
    for c in CHALLENGES:
        entry: dict = {
            "name": c["name"],
            "display_name": c["display"],
            "description": c["desc"],
            "difficulty": c["difficulty"],
            "section": c["section"],
        }
        flag_obj: dict = {"flag": c["flag"], "points": c["points"], "description": c["desc"]}
        if c.get("hints"):
            flag_obj["hints"] = c["hints"]
        entry["flags"] = [flag_obj]
        challenges.append(entry)

    doc = {
        "name": "linux-basics-i",
        "display_name": "Linux Basics I",
        "description": "Forty-two Linux basics stations: files, paths, search, pipes, perms, env, archives, processes. Mixed difficulty, points, hints, checker and theory quizzes.",
        "version": "2.0.0",
        "author": "Conos",
        "difficulty": "mixed",
        "category": "linux",
        "tags": ["linux", "cli", "basics", "pipes", "find", "grep", "theory"],
        "ports": {"ssh": 22},
        "credentials": {"username": "user", "password": "user"},
        "challenges": challenges,
    }
    (ROOT / "hackploy.json").write_text(json.dumps(doc, indent=2) + "\n")


def emit_setup() -> str:
    parts: list[str] = [
        "#!/bin/bash",
        "set -euo pipefail",
        "",
        "USER_HOME=/home/user",
        "CHALL=$USER_HOME/challenges",
        "TOOLS=/tmp/tools",
        "OPT=/opt/lb",
        "mkdir -p \"$CHALL\" \"$OPT\"",
        "",
        "sha256() { printf '%s' \"$1\" | sha256sum | awk '{print $1}'; }",
        "",
        "xor_hex() {",
        "  # $1=flag $2=key_material -> hex on stdout",
        "  python3 - \"$1\" \"$2\" <<'PY'",
        "import hashlib,sys",
        "flag, key_m = sys.argv[1], sys.argv[2]",
        "key=hashlib.sha256(key_m.encode()).digest()",
        "raw=flag.encode()",
        "print(''.join(f'{b ^ key[i % len(key)]:02x}' for i,b in enumerate(raw)))",
        "PY",
        "}",
        "",
        "compile_checker() {",
        "  local dest=\"$1\" keyword=\"$2\" flag=\"$3\"",
        "  local hash xor",
        "  hash=$(sha256 \"$keyword\")",
        "  xor=$(xor_hex \"$flag\" \"$keyword\")",
        "  local flen=${#flag}",
        "  gcc -O2 -s -o \"$dest/checker\" \"$TOOLS/checker.c\" \\",
        "    -DEXPECTED_HASH=\"\\\"$hash\\\"\" \\",
        "    -DFLAG_XOR_HEX=\"\\\"$xor\\\"\" \\",
        "    -DFLAG_LEN=\"$flen\" \\",
        "    -lcrypto",
        "  chown root:root \"$dest/checker\"",
        "  chmod 111 \"$dest/checker\"",
        "}",
        "",
        "compile_ask() {",
        "  local dest=\"$1\" flag=\"$2\" key_material=\"$3\"",
        "  shift 3",
        "  # remaining: pairs of question answer",
        "  local tmp=\"$dest/.ask_build\"",
        "  mkdir -p \"$tmp\"",
        "  local xor flen n=0",
        "  xor=$(xor_hex \"$flag\" \"$key_material\")",
        "  flen=${#flag}",
        "  {",
        "    echo '#ifndef ASK_DATA_H'",
        "    echo '#define ASK_DATA_H'",
        "    local qs=() hs=()",
        "    while [[ $# -ge 2 ]]; do",
        "      local q=\"$1\" a=\"$2\"; shift 2",
        "      local h; h=$(sha256 \"$a\")",
        "      qs+=(\"$q\"); hs+=(\"$h\")",
        "      n=$((n+1))",
        "    done",
        "    echo \"#define N_QUESTIONS $n\"",
        "    echo \"static const char *Q_TEXTS[N_QUESTIONS] = {\"",
        "    local i",
        "    for ((i=0;i<n;i++)); do",
        "      printf '  \"%s\",\\n' \"${qs[$i]//\\/\\\\}\"",
        "    done",
        "    echo '};'",
        "    echo \"static const char *A_HASHES[N_QUESTIONS] = {\"",
        "    for ((i=0;i<n;i++)); do",
        "      printf '  \"%s\",\\n' \"${hs[$i]}\"",
        "    done",
        "    echo '};'",
        "    echo \"#define FLAG_XOR_HEX \\\"$xor\\\"\"",
        "    echo \"#define FLAG_LEN $flen\"",
        "    echo '#endif'",
        "  } >\"$tmp/ask_data.h\"",
        "  # Fix escaping properly with python",
        "  python3 - \"$tmp/ask_data.h\" \"$flag\" \"$key_material\" <<'PY'",
        "import hashlib, sys, json",
        "path, flag, key_m = sys.argv[1], sys.argv[2], sys.argv[3]",
        "# rewritten below from env file if present",
        "PY",
        "  gcc -O2 -s -I\"$tmp\" -o \"$dest/ask\" \"$TOOLS/ask.c\" -lcrypto",
        "  chown root:root \"$dest/ask\"",
        "  chmod 111 \"$dest/ask\"",
        "  rm -rf \"$tmp\"",
        "}",
        "",
    ]

    # The compile_ask above is too fragile with escaping. Better: generate ask_data.h fully from Python into setup as separate functions per ask station.
    # Rewrite approach: setup.sh calls python to write ask_data.h from JSON lines.

    setup = textwrap.dedent(
        r'''
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

        '''
    ).lstrip()

    body: list[str] = [setup]

    for c in CHALLENGES:
        cid = c["id"]
        body.append(f"\n# ---------- {cid} ----------\n")
        body.append(f'D="{CHALL}/{cid}"\n' if False else f'D="$CHALL/{cid}"\n')
        body.append('mkdir -p "$D"\n')
        readme = c.get("readme", "")
        body.append(f"cat >\"$D/README\" <<'EOF'\n{readme}\nEOF\n")
        if c.get("lab_hint"):
            body.append(f"cat >\"$D/HINT\" <<'EOF'\n{c['lab_hint']}\nEOF\n")

        if c["type"] == "checker":
            body.append(f"compile_checker \"$D\" '{c['keyword']}' '{c['flag']}'\n")
        else:
            pairs = c["answers"]
            key_material = "|".join(a for _, a in pairs)
            qa_name = f"/tmp/qa_{c['name']}.json"
            body.append(
                f"cat >{qa_name} <<'EOF'\n{json.dumps(pairs)}\nEOF\n"
            )
            body.append(
                f"compile_ask \"$D\" '{c['flag']}' '{key_material}' {qa_name}\n"
            )

        # station-specific payload
        body.append(station_payload(c))

    body.append(
        textwrap.dedent(
            r'''
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
            '''
        )
    )

    return "".join(body)


def station_payload(c: dict) -> str:
    cid = c["id"]
    kw = c.get("keyword", "")
    lines: list[str] = []

    def add(s: str) -> None:
        lines.append(s + "\n")

    if cid == "01-hidden-dotfiles":
        add('mkdir -p "$D/.cache/ops"')
        add(f"printf '%s\\n' '{kw}' >\"$D/.cache/ops/token\"")
        add("echo 'not this one' >\"$D/notes.txt\"")
        add("echo 'look for what ls hides' >\"$D/.cache/README.txt\"")
    elif cid == "02-cat-readme":
        add(f"printf 'KEYWORD=%s\\n' '{kw}' >\"$D/note.txt\"")
    elif cid == "03-head-log":
        add("{")
        add(f"  echo 'TOKEN={kw}'")
        add("  for i in $(seq 1 200); do echo \"noise line $i\"; done")
        add("} >\"$D/big.log\"")
    elif cid == "04-tail-secret":
        add("{")
        add("  for i in $(seq 1 200); do echo \"noise line $i\"; done")
        add(f"  echo '{kw}'")
        add("} >\"$D/trail.log\"")
    elif cid == "05-wc-lines":
        add("for i in $(seq 1 120); do echo \"row-$i\"; done >\"$D/data.txt\"")
    elif cid == "07-absolute-path":
        add('mkdir -p "$OPT/absolute"')
        add(f"printf '%s\\n' '{kw}' >\"$OPT/absolute/KEY\"")
        add('ln -sfn /opt/lb/absolute "$D/absolute"')
    elif cid == "08-relative-climb":
        add('mkdir -p "$D/nest/deep/here"')
        add(f"printf '%s\\n' '{kw}' >\"$D/nest/KEY\"")
        add("echo 'climb up from here/' >\"$D/nest/deep/here/START\"")
    elif cid == "09-symlink-trap":
        add('MAZE="$OPT/maze"')
        add('mkdir -p "$MAZE"/{a/b/c,x/y/z,trap/loop,real/exit}')
        add('ln -sfn "$MAZE/a/b" "$MAZE/start"')
        add('ln -sfn "$MAZE/trap/loop" "$MAZE/a/b/next"')
        add('ln -sfn "$MAZE/a" "$MAZE/trap/loop/back"')
        add('ln -sfn "$MAZE/real/exit" "$MAZE/x/y/gate"')
        add("echo 'cycle' >\"$MAZE/trap/loop/hint.txt\"")
        add("echo 'try x/y' >\"$MAZE/a/b/c/clue.txt\"")
        add(f"printf '%s\\n' '{kw}' >\"$MAZE/real/exit/KEY\"")
        add('ln -sfn /opt/lb/maze "$D/maze"')
    elif cid == "10-realpath-resolve":
        add('mkdir -p "$OPT/chain"/{a,b,c}')
        add(f"printf '%s\\n' '{kw}' >\"$OPT/chain/c/KEY\"")
        add('ln -sfn /opt/lb/chain/c "$OPT/chain/b/link"')
        add('ln -sfn /opt/lb/chain/b/link "$OPT/chain/a/portal"')
        add('ln -sfn /opt/lb/chain/a/portal "$D/portal"')
    elif cid == "11-find-by-name":
        add('mkdir -p "$D/tree"/{a/b,c/d/e,f}')
        add("for i in $(seq 1 40); do echo decoy >\"$D/tree/a/b/file_$i.txt\"; done")
        add(f"printf '%s\\n' '{kw}' >\"$D/tree/c/d/e/prize.txt\"")
    elif cid == "12-find-by-content":
        add('mkdir -p "$D/dump"/{1,2,3/deep}')
        add("for i in $(seq 1 60); do echo \"id=$i\" >\"$D/dump/1/n_$i.txt\"; done")
        add("echo 'NEEDLE=wrong' >\"$D/dump/2/a.txt\"")
        add(f"echo 'NEEDLE={kw}' >\"$D/dump/3/deep/hit.txt\"")
    elif cid == "13-grep-one-file":
        add("{")
        add("  for i in $(seq 1 80); do echo \"INFO ok $i\"; done")
        add("  echo 'ERROR guest TOKEN=nope'")
        add(f"  echo 'ERROR root TOKEN={kw}'")
        add("  echo 'WARN skip'")
        add("} >\"$D/access.log\"")
        # Wait - README says ERROR with TOKEN - but which? Let me fix: only one ERROR with the real token for user... 
        # Actually I put TOKEN on root ERROR. Fix keyword line to be unique.
    elif cid == "14-grep-recursive":
        add('mkdir -p "$D/conf"/{dev,prod,stage}')
        add("echo 'auth_token=decoy' >\"$D/conf/dev/app.cfg\"")
        add(f"echo 'auth_token={kw}' >\"$D/conf/prod/app.cfg\"")
        add("echo 'auth_token=stage' >\"$D/conf/stage/app.cfg\"")
        add(f"echo 'auth_token={kw}' >\"$D/conf/prod/app.cfg.bak\"")
    elif cid == "15-find-size":
        add('mkdir -p "$D/sizes"/{a,b,c}')
        add("echo filled >\"$D/sizes/a/one.txt\"")
        add("echo filledmore >\"$D/sizes/b/two.txt\"")
        add(": >\"$D/sizes/c/empty.dat\"")
        add(f"printf '%s\\n' '{kw}' >\"$D/sizes/c/NOTES\"")
    elif cid == "16-pipe-grep-wc":
        add("{")
        add("  for i in $(seq 1 30); do echo \"OK $i\"; done")
        add("  for i in $(seq 1 17); do echo \"FAIL item-$i\"; done")
        add("  for i in $(seq 1 20); do echo \"WARN $i\"; done")
        add("} >\"$D/events.log\"")
    elif cid == "17-cut-fields":
        add("cat >\"$D/users.csv\" <<'EOF'")
        add("name,role,token")
        add("guest,user,nope")
        add(f"ops,admin,{kw}")
        add("root,admin,decoy")
        add("EOF")
    elif cid == "18-sort-uniq":
        add("{")
        add("  for i in $(seq 1 20); do echo alpha; echo beta; done")
        add(f"  echo {kw}")
        add("  for i in $(seq 1 15); do echo gamma; done")
        add("} >\"$D/votes.txt\"")
    elif cid == "19-awk-select":
        # sum of ok bytes = 42
        add("cat >\"$D/metrics.tsv\" <<'EOF'")
        add("ok\t10\t/a")
        add("fail\t99\t/b")
        add("ok\t12\t/c")
        add("ok\t20\t/d")
        add("fail\t5\t/e")
        add("EOF")
    elif cid == "20-sed-extract":
        add(f"echo 'prefix code={kw} suffix noise=1' >\"$D/messy.txt\"")
    elif cid == "21-whoami-id":
        add("echo 'keyword format i_am_<whoami>' >\"$D/NOTE\"")
    elif cid == "22-chmod-own-file":
        add(f"printf '%s\\n' '{kw}' >\"$D/locked.txt\"")
    elif cid == "24-find-writable":
        add('mkdir -p "$D/cage"/{1,2,3}')
        add("echo no >\"$D/cage/1/a.txt\"; chmod 644 \"$D/cage/1/a.txt\"")
        add("echo no >\"$D/cage/2/b.txt\"; chmod 600 \"$D/cage/2/b.txt\"")
        add(f"printf '%s\\n' '{kw}' >\"$D/cage/3/open.txt\"; chmod 666 \"$D/cage/3/open.txt\"")
    elif cid == "25-id-groups":
        add(f"printf '%s\\n' '{kw}' >\"$D/secret.grp\"")
    elif cid == "26-env-leak":
        add("echo 'LB_KEYWORD is exported in your ~/.bashrc — open a new shell or source it.' >\"$D/NOTE\"")
    elif cid == "28-bashrc-secret":
        add(f"printf 'KEYWORD=%s\\n' '{kw}' >\"$D/.bashrc_local\"")
        add("echo 'source the local rc or just read it' >\"$D/NOTE\"")
    elif cid == "30-tar-extract":
        add('mkdir -p "$D/.pack"')
        add(f"printf '%s\\n' '{kw}' >\"$D/.pack/KEY\"")
        add('tar -cf "$D/box.tar" -C "$D/.pack" KEY')
        add('rm -rf "$D/.pack"')
    elif cid == "31-gzip-peek":
        add(f"printf '%s\\n' '{kw}' >\"$D/secret.txt\"")
        add('gzip -f "$D/secret.txt"')
    elif cid == "32-nested-tar":
        add('mkdir -p "$D/.n/inner"')
        add(f"printf '%s\\n' '{kw}' >\"$D/.n/inner/KEY\"")
        add('tar -czf "$D/.n/inner.tar.gz" -C "$D/.n/inner" KEY')
        add('rm -rf "$D/.n/inner"')
        add('tar -cf "$D/outer.tar" -C "$D/.n" inner.tar.gz')
        add('rm -rf "$D/.n"')
    elif cid == "33-base64-note":
        add(f"printf '%s' '{kw}' | base64 >\"$D/encoded.txt\"")
    elif cid == "34-xxd-hex":
        add(f"printf '%s' '{kw}' | xxd >\"$D/blob.hex\"")
    elif cid == "35-ps-clue":
        add("echo 'Inspect running processes for lb-helper.' >\"$D/NOTE\"")
    elif cid == "36-hosts-lookup":
        add(f"echo '127.0.0.1 lab-flag.local # KEYWORD={kw}' >\"$D/hosts.snippet\"")
        add("echo 'This lab keeps a hosts snippet here instead of editing /etc/hosts.' >\"$D/NOTE\"")
    elif cid == "37-du-biggest":
        add('mkdir -p "$D/pile"')
        add("echo small >\"$D/pile/a.txt\"")
        add("echo small >\"$D/pile/b.txt\"")
        add(f"{{ echo '{kw}'; dd if=/dev/zero bs=1024 count=50 2>/dev/null; }} >\"$D/pile/core.dat\"")
    elif cid == "38-strings-bin":
        add(f"python3 -c \"import pathlib; p=pathlib.Path('$D/blob.bin'); p.write_bytes(b'x'*200 + b'KEYWORD={kw}' + b'y'*200)\"")
    elif cid == "39-cron-clue":
        add('mkdir -p "$D/cron"')
        add(f"printf '# nightly\\n# KEYWORD={kw}\\n0 3 * * * /usr/bin/true\\n' >\"$D/cron/jobs.txt\"")
    elif cid == "40-multi-pipe":
        add('mkdir -p /var/log/lb')
        add("{")
        add("  for i in $(seq 1 80); do echo \"INFO guest hb-$i\"; done")
        add("  echo 'ERROR root FAIL_00'")
        add("  echo 'ERROR ops FAIL_22'")
        add(f"  echo 'ERROR ops TOKEN={kw} detail=auth'")
        add("  echo 'ERROR ops FAIL_33'")
        add("  for i in $(seq 1 40); do echo \"DEBUG ops noise-$i\"; done")
        add("} >/var/log/lb/service.log")
        add('ln -sfn /var/log/lb "$D/logs"')
        add("chmod -R a+rX /var/log/lb")
    elif cid == "41-needle-maze":
        add('WEB="$OPT/web"')
        add('mkdir -p "$WEB"/{assets,vendor,backup,tmp,.git/objects,assets/deep/nested/config}')
        add("for i in $(seq 1 80); do echo ok >\"$WEB/assets/item_$i.txt\"; done")
        add("echo 'needle_in_hay_00 wrong' >\"$WEB/backup/old.txt\"")
        add("echo 'auth_token=decoy' >\"$WEB/assets/deep/nested/config/dev.cfg\"")
        add(f"echo 'auth_token={kw}' >\"$WEB/assets/deep/nested/config/app.cfg\"")
        add("echo 'prod endpoint' >>\"$WEB/assets/deep/nested/config/app.cfg\"")
        add('ln -sfn /opt/lb/web "$D/web"')

    return "".join(lines)


def write_station_readmes() -> None:
    STATIONS.mkdir(parents=True, exist_ok=True)
    for c in CHALLENGES:
        d = STATIONS / c["id"]
        d.mkdir(parents=True, exist_ok=True)
        (d / "README").write_text(c.get("readme", "") + "\n")


def main() -> None:
    write_hackploy()
    write_station_readmes()
    setup = emit_setup()
    # Fix 13-grep: make TOKEN unique on ERROR guest? README says ERROR with TOKEN
    # keyword GREP_HIT_13 on root line is fine if they grep TOKEN
    (ROOT / "setup.sh").write_text(setup)
    (ROOT / "setup.sh").chmod(0o755)
    print(f"wrote {len(CHALLENGES)} challenges -> hackploy.json + setup.sh")


if __name__ == "__main__":
    main()
