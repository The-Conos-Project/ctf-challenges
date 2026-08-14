#!/bin/bash
set -e

CHALLENGE_NAME="${CHALLENGE_NAME:-}"

setup_bash_history() {
    mkdir -p /opt/challenges/bash-history
    cat > /opt/challenges/bash-history/START_HERE <<'EOF'
Previous commands executed on this system may contain secrets. Look for where the shell stores its command history.
EOF
    echo 'echo "flag{history_repeats_itself}"' >> /etc/skel/.bash_history
    echo 'echo "flag{history_tells_no_lies}"' >> /etc/skel/.bash_history
}

setup_cat_reading() {
    mkdir -p /opt/challenges/cat-reading
    cat > /opt/challenges/cat-reading/START_HERE <<'EOF'
Text files can reveal their contents when read properly. Some are in plain sight, others require deeper inspection.
EOF
    echo "flag{cat_content_revealed}" > /opt/challenges/cat-reading/flag.txt
    echo "flag{less_is_more}" > /opt/challenges/cat-reading/.secret_flag
}

setup_env_vars() {
    mkdir -p /opt/challenges/env-vars
    cat > /opt/challenges/env-vars/START_HERE <<'EOF'
Processes inherit settings from their environment. Some secrets are stored as variables rather than files.
EOF
    echo "export SECRET_FLAG=flag{env_variable_found}" > /etc/profile.d/flag.sh
}

setup_file_listing() {
    mkdir -p /opt/challenges/file-listing
    cat > /opt/challenges/file-listing/START_HERE <<'EOF'
Not all files are visible with basic listing commands. Some intentionally hide from casual observers.
EOF
    echo "This is just a decoy text file." > /opt/challenges/file-listing/readme.txt
    echo "flag{find_all_visible_files}" > /opt/challenges/file-listing/.hidden_flag
    echo "flag{dotfiles_revealed}" > /opt/challenges/file-listing/.another_flag
}

setup_find_search() {
    mkdir -p /opt/challenges/find-search/nested/level1/level2/level3/level4
    cat > /opt/challenges/find-search/START_HERE <<'EOF'
Files can be buried deep within directory trees. Manual exploration is inefficient.
EOF
    echo "flag{find_hidden_treasure}" > /opt/challenges/find-search/nested/level1/level2/level3/level4/secret_flag.txt
    mkdir -p /opt/challenges/find-search/another/path
    echo "flag{find_all_treasures}" > /opt/challenges/find-search/another/path/second_flag.txt
}

setup_grep_pattern() {
    mkdir -p /opt/challenges/grep-pattern
    cat > /opt/challenges/grep-pattern/START_HERE <<'EOF'
Large text files contain patterns. Learning to filter them is essential.
EOF
    for i in {1..200}; do
        echo "127.0.0.1 - - [14/Aug/2026:08:59:$i] \"GET /index.html HTTP/1.1\" 200 4096" >> /opt/challenges/grep-pattern/access.log
    done
    echo "192.168.1.5 - - [14/Aug/2026:09:00:00] \"POST /submit HTTP/1.1\" 200 flag{grep_success_pattern}" >> /opt/challenges/grep-pattern/access.log
    for i in {201..400}; do
        echo "127.0.0.1 - - [14/Aug/2026:09:01:$i] \"GET /styles.css HTTP/1.1\" 200 1024" >> /opt/challenges/grep-pattern/access.log
    done
    echo "Additional log entry with flag{grep_context_king} nearby." >> /opt/challenges/grep-pattern/access.log
}

setup_network_check() {
    mkdir -p /opt/challenges/network-check /tmp/web
    cat > /opt/challenges/network-check/START_HERE <<'EOF'
Running services on network interfaces can reveal information.
EOF
    echo "flag{local_port_handshake}" > /tmp/web/index.html
    cd /tmp/web && (python3 -m http.server 8080 --bind 127.0.0.1 >/dev/null 2>&1 &)
}

setup_perm_check() {
    mkdir -p /opt/challenges/perm-check/restricted
    cat > /opt/challenges/perm-check/START_HERE <<'EOF'
File permissions control access. Some combinations allow access even when listing is denied.
EOF
    echo "flag{permission_bypass}" > /opt/challenges/perm-check/restricted/flag.txt
    chmod 711 /opt/challenges/perm-check/restricted
    chmod 444 /opt/challenges/perm-check/restricted/flag.txt
}

setup_proc_inspect() {
    mkdir -p /opt/challenges/proc-inspect
    cat > /opt/challenges/proc-inspect/START_HERE <<'EOF'
Running processes expose their identity through the process table.
EOF
    (exec -a "secret-agent-flag{process_secret_id}" sleep 99999) &
    (exec -a "watcher-flag{pid_hunter}" sleep 99999) &
}

setup_tar_extract() {
    mkdir -p /opt/challenges/tar-extract /tmp/build-arch
    cat > /opt/challenges/tar-extract/START_HERE <<'EOF'
Archives bundle multiple files. Extracting them requires the right tool.
EOF
    echo "flag{archive_extracted_success}" > /tmp/build-arch/flag.txt
    echo "flag{archive_contents_known}" > /tmp/build-arch/second.txt
    tar -czf /opt/challenges/tar-extract/archive.tar.gz -C /tmp/build-arch flag.txt second.txt
    rm -rf /tmp/build-arch
}

if [[ -z "$CHALLENGE_NAME" ]]; then
    setup_bash_history
    setup_cat_reading
    setup_env_vars
    setup_file_listing
    setup_find_search
    setup_grep_pattern
    setup_network_check
    setup_perm_check
    setup_proc_inspect
    setup_tar_extract
else
    case "$CHALLENGE_NAME" in
        bash-history) setup_bash_history ;;
        cat-reading) setup_cat_reading ;;
        env-vars) setup_env_vars ;;
        file-listing) setup_file_listing ;;
        find-search) setup_find_search ;;
        grep-pattern) setup_grep_pattern ;;
        network-check) setup_network_check ;;
        perm-check) setup_perm_check ;;
        proc-inspect) setup_proc_inspect ;;
        tar-extract) setup_tar_extract ;;
        *) echo "Unknown challenge: $CHALLENGE_NAME" ;;
    esac
fi

chmod -R a=rX /opt/challenges
find /opt/challenges -type d -exec chmod 755 {} \;
