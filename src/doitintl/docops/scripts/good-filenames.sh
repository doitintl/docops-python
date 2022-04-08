#!/bin/sh -e

# Find files that should be renamed (for clarity and consistency)
# =============================================================================

# Usage: ./bin/good-filenames.sh

# ANSI formatting
RED='\x1b[1;31m'
RESET='\x1b[0m'

# Markdown
# -----------------------------------------------------------------------------

# TODO: Implement checks for Markdown filenames

# Assets
# -----------------------------------------------------------------------------

ASSET_PATTERN='\.(csv|gif|png)$'
ALLOWED_PREFIXES='^(cmp|aws|gcp|ms|slack|cloudhealth|feedback-hub|email|file)'
ALLOWED_CHARS='[a-z0-9.-]+'
DISALLOWED_STEMS='(--|[a-z][0-9]|image|shot|[0-9][^0-9.])'
DISALLOWED_STEMS_FILTER='s,(-s3|s3-|-office-365),,'

check_filename() {
    file="${1}"
    basename="$(basename "${file}")"
    echo "${basename}" | grep -Eq "${ALLOWED_PREFIXES}" || echo 'prefix'
    echo "${basename}" | grep -Eq "${ALLOWED_CHARS}" || echo 'characters'
    echo "${basename}" |
        sed -E "${DISALLOWED_STEMS_FILTER}" |
        grep -Eqv "${DISALLOWED_STEMS}" || echo 'stem'
}

tmp_errors="$(mktemp)"
fdfind --no-ignore --type f "${ASSET_PATTERN}" |
    while read -r file; do
        check_filename "${file}" |
            sed -E "s,(.*),${file} (\1)," >>"${tmp_errors}"
    done

status_code=0
if test -s "${tmp_errors}"; then
    printf 'Disallowed filenames:\n\n'
    sed -E "s,^(.*),${RED}\1${RESET}," <"${tmp_errors}"
    status_code=1
fi
rm -f "${tmp_errors}"
exit "${status_code}"
