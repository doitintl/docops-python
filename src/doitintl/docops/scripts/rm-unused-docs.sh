#!/bin/sh -e

# Remove unused documents from the Git repository
# =============================================================================

# Usage: ./bin/rm-unused-assets.sh [-d|--dry-run]

# A document (i.e., a Markdown file) is considered unused if no other documents
# in the GitBook space (i.e., the `docs` directory) reference it.

# POSIX locale
LC_ALL=C
export LC_ALL

# ANSI formatting
RED='\x1b[1;31m'
RESET='\x1b[0m'

DOCS_DIR=gitbook/cmp

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
(cd "${DOCS_DIR}" && fdfind --ignore-case '\.md$') |
    while read -r file; do
        if test "${file}" = 'SUMMARY.md'; then
            continue
        fi
        basename="$(basename "${file}")"
        if ! grep -rsqF "${basename}" --include='*.md' "./${DOCS_DIR}"; then
            echo "${DOCS_DIR}/${file}" >>"${tmp_errors}"
        fi
    done

status_code=0
if test -s "${tmp_errors}"; then
    if test "${dry_run}" = 0; then
        xargs git rm -f --ignore-unmatch -- <"${tmp_errors}"
        xargs rm -fv <"${tmp_errors}"
    else
        printf 'Unused documents:\n\n'
        sed -E "s,^(.*),${RED}\1${RESET}," <"${tmp_errors}"
        status_code=1
    fi
fi
rm -f "${tmp_errors}"
exit "${status_code}"
