#!/bin/sh -e

# Wrap the `brok` command to provide configuration
# =============================================================================

# Usage: ./bin/brok.sh

# https://github.com/smallhadroncollider/brok

# POSIX locale
LC_ALL=C
export LC_ALL

# ANSI formatting
BLUE='\x1b[1;34m'
RED='\x1b[1;31m'
RESET='\x1b[0m'

tmp_errors="$(mktemp)"

run_brok() {
    fdfind --hidden --ignore-case --type f --print0 '\.md$$' |
        xargs -0 brok \
            --check-certs --only-failures --no-color --ignore \
            'https://fonts.gstatic.com' \
            'https://www.googleapis.com/robot' \
            'https://accounts.google.com/o/oauth2/token' \
            'https://help.fullstory.com/'
}

tmp_errors="$(mktemp)"
status_code=0
if ! run_brok >/dev/null 2>"${tmp_errors}"; then
    sed '/^$/d' <"${tmp_errors}" |
        sed -E "s,\[(.*)\],${BLUE}\1${RESET}," |
        sed -E "s,.+\((.+)\): (.+),  ${RED}HTTP \1: \2 ${RESET},"
    status_code=1
fi
rm -f "${tmp_errors}"
exit "${status_code}"
