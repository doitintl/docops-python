#!/bin/sh -e

# Wrap the `markdown-link-check` command to provide configuration
# =============================================================================

# Usage: ./bin/markdown-link-check.sh

# https://github.com/tcort/markdown-link-check

# This program has been configured (via the `.markdown-link-check.json` file)
# to ignore external links. As a result, this check only tests internal links
# and runs much faster.

# You can check external links with the `brok.sh` script, which caches its
# results (speeding up subsequent runs).

# POSIX locale
LC_ALL=C
export LC_ALL

# ANSI formatting
BLUE='\x1b[1;34m'
RED='\x1b[1;31m'
RESET='\x1b[0m'

run_markdown_link_check() {
    fdfind --hidden --ignore-case --type f --print0 '\.md$$' |
        xargs -0 markdown-link-check \
            --config .markdown-link-check.json \
            --quiet \
            --retry 2>/dev/null
}

tmp_errors="$(mktemp)"
if ! run_markdown_link_check >"${tmp_errors}"; then
    grep --before-context 1 '\[' <"${tmp_errors}" |
        grep -E '(FILE|Status)' |
        sed -E "s,^FILE: (.*),${BLUE}\1${RESET}," |
        sed -E "s,^(.+\]) ([^ ]+) .+ (.+),${RED}  HTTP \3: \2 ${RESET},"
    exit 1
fi
rm -f "${tmp_errors}"
