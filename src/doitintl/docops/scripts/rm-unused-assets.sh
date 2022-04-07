#!/bin/sh -e

# Remove unused assets from the Git repository
# =============================================================================

# Usage: ./bin/rm-unused-assets.sh [--dry-run]

# An asset (e.g., a PNG file or a CSV file) is considered to be unused if no
# documents (i.e., Markdown files) in the GitBook space (i.e., the `docs`
# directory) reference it.

# POSIX locale
LC_ALL=C
export LC_ALL

# ANSI formatting
RED='\x1b[1;31m'
RESET='\x1b[0m'

DOCS_DIR=gitbook/cmp
ASSETS_DIR=.gitbook/assets

dry_run=0
for arg in "$@"; do
    case "${arg}" in
    -d | --dry-run)
        dry_run=1
        shift
        ;;
    -*)
        echo "ERROR: Unknown option: ${arg}"
        exit 1
        ;;
    *) ;;
    esac
done

tmp_errors="$(mktemp)"
(cd "${DOCS_DIR}/${ASSETS_DIR}" && fdfind --no-ignore) |
    while read -r file; do
        pattern="assets/$(basename "${file}")"
        if ! grep -rsqF "${pattern}" --include='*.md' "${DOCS_DIR}"; then
            echo "${DOCS_DIR}/${ASSETS_DIR}/${file}" >>"${tmp_errors}"
        fi
    done

status_code=0
if test -s "${tmp_errors}"; then
    if test "${dry_run}" = 0; then
        xargs git rm -f --ignore-unmatch -- <"${tmp_errors}"
        xargs rm -fv <"${tmp_errors}"
    else
        printf 'Unused assets:\n\n'
        sed -E "s,^(.*),${RED}\1${RESET}," <"${tmp_errors}"
        status_code=1
    fi
fi
rm -f "${tmp_errors}"
exit "${status_code}"
