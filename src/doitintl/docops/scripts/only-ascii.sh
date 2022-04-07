#!/bin/sh -e

# Find text files with non-ASCII characters
# =============================================================================

# Usage: ./bin/only-ascii.sh

# For Markdown files, convert non-ASCII characters to HTML entities:
#
# - https://mothereff.in/html-entities
#
#   Note: Select the "allow named character references" checkbox and use named
#   entities whenever available.
#
# If no named entity is available, check for similar characters:
#
# - https://www.toptal.com/designers/htmlarrows/

# POSIX locale
LC_ALL=C
export LC_ALL

# ANSI formatting
RED='\x1b[1;31m'
RESET='\x1b[0m'

test_encoding() {
    target="${1}"
    file --mime-encoding "${target}" |
        grep -v 'us-ascii' |
        sed -E "s,: (.*),: ${RED}\1${RESET},"
}

tmp_errors="$(mktemp)"
fdfind -H -t f --size +1b | while read -r file; do
    test_encoding "${file}" | tee -a "${tmp_errors}"
done

if test -s "${tmp_errors}"; then
    rm -f "${tmp_errors}"
    exit 1
fi
