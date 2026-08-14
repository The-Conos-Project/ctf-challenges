#!/bin/bash
set -e

# Challenge 1: bash-history
mkdir -p /opt/challenges/bash-history
echo "Find the flag in the command execution history." > /opt/challenges/bash-history/START_HERE
echo 'echo "flag{history_repeats_itself}"' >> /etc/skel/.bash_history
echo '# Run the hidden cron job: echo "flag{history_tells_no_lies}"' >> /etc/skel/.bash_history

# Challenge 2: cat-reading
mkdir -p /opt/challenges/cat-reading
echo "Read the contents of the flag.txt file." > /opt/challenges/cat-reading/START_HERE
echo "flag{cat_content_revealed}" > /opt/challenges/cat-reading/flag.txt
echo "flag{less_is_more}" > /opt/challenges/cat-reading/.secret_flag

# Challenge 3: env-vars
mkdir -p /opt/challenges/env-vars
echo "Check the environment variables of your shell." > /opt/challenges/env-vars/START_HERE
echo "export SECRET_FLAG=flag{env_variable_found}" > /etc/profile.d/flag.sh

# Challenge 4: file-listing
mkdir -p /opt/challenges/file-listing
echo "Find the hidden file starting with a dot in this directory." > /opt/challenges/file-listing/START_HERE
echo "This is just a decoy text file." > /opt/challenges/file-listing/readme.txt
echo "flag{find_all_visible_files}" > /opt/challenges/file-listing/.hidden_flag
echo "flag{dotfiles_revealed}" > /opt/challenges/file-listing/.another_flag

# Challenge 5: find-search
mkdir -p /opt/challenges/find-search/nested/level1/level2/level3/level4
echo "Find the file named secret_flag.txt hidden somewhere in this tree." > /opt/challenges/find-search/START_HERE
echo "flag{find_hidden_treasure}" > /opt/challenges/find-search/nested/level1/level2/level3/level4/secret_flag.txt
mkdir -p /opt/challenges/find-search/another/path
echo "flag{find_all_treasures}" > /opt/challenges/find-search/another/path/second_flag.txt

# Challenge 6: grep-pattern
mkdir -p /opt/challenges/grep-pattern
echo "Find the line containing the flag in the access.log." > /opt/challenges/grep-pattern/START_HERE
for i in {1..200}; do
    echo "127.0.0.1 - - [14/Aug/2026:08:59:$i] \"GET /index.html HTTP/1.1\" 200 4096" >> /opt/challenges/grep-pattern/access.log
done
echo "192.168.1.5 - - [14/Aug/2026:09:00:00] \"POST /submit HTTP/1.1\" 200 flag{grep_success_pattern}" >> /opt/challenges/grep-pattern/access.log
for i in {201..400}; do
    echo "127.0.0.1 - - [14/Aug/2026:09:01:$i] \"GET /styles.css HTTP/1.1\" 200 1024" >> /opt/challenges/grep-pattern/access.log
done
echo "Additional log entry with flag{grep_context_king} nearby." >> /opt/challenges/grep-pattern/access.log

# Challenge 7: network-check
mkdir -p /opt/challenges/network-check /tmp/web
echo "flag{local_port_handshake}" > /tmp/web/index.html
echo "Interact with localhost on port 8080." > /opt/challenges/network-check/START_HERE
cd /tmp/web && (python3 -m http.server 8080 --bind 127.0.0.1 >/dev/null 2>&1 &)

# Challenge 8: perm-check
mkdir -p /opt/challenges/perm-check/restricted
echo "Try to read the file flag.txt inside /opt/challenges/perm-check/restricted/." > /opt/challenges/perm-check/START_HERE
echo "flag{permission_bypass}" > /opt/challenges/perm-check/restricted/flag.txt
chmod 711 /opt/challenges/perm-check/restricted
chmod 444 /opt/challenges/perm-check/restricted/flag.txt

# Challenge 9: proc-inspect
mkdir -p /opt/challenges/proc-inspect
echo "Find the flag in a running process." > /opt/challenges/proc-inspect/START_HERE
(exec -a "secret-agent-flag{process_secret_id}" sleep 99999) &
(exec -a "watcher-flag{pid_hunter}" sleep 99999) &

# Challenge 10: tar-extract
mkdir -p /opt/challenges/tar-extract /tmp/build-arch
echo "flag{archive_extracted_success}" > /tmp/build-arch/flag.txt
echo "flag{archive_contents_known}" > /tmp/build-arch/second.txt
tar -czf /opt/challenges/tar-extract/archive.tar.gz -C /tmp/build-arch flag.txt second.txt
rm -rf /tmp/build-arch
echo "Decompress the archive.tar.gz file in this directory." > /opt/challenges/tar-extract/START_HERE

chmod -R a=rX /opt/challenges
find /opt/challenges -type d -exec chmod 755 {} \;
