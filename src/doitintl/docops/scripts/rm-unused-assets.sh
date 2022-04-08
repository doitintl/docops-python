#!/bin/sh -e

# Remove unused assets from the Git repository
# =============================================================================

# Usage: ./bin/rm-unused-assets.sh [-f|--fix]

# An asset (e.g., a PNG file or a CSV file) is considered to be unused if no
# documents (i.e., Markdown files) in the GitBook space (i.e., the `docs`
# directory) reference it.

# ANSI formatting
RED='\x1b[1;31m'
RESET='\x1b[0m'

ASSET_PATTERN='\.(csv|gif|png)$'
MARKUP_PATTERN='\.(md|mdx|rst)$'

fix=0
for arg in "$@"; do
    case "${arg}" in
    -f | --fix)
        fix=1
        shift
        ;;
    -*)
        echo "ERROR: Unknown option: ${arg}"
        exit 1
        ;;
    *) ;;
    esac
done

tmp_markup="$(mktemp)"
fdfind --no-ignore "${MARKUP_PATTERN}" --print0 |
    xargs -0 cat >"${tmp_markup}"

tmp_errors="$(mktemp)"
fdfind --no-ignore "${ASSET_PATTERN}" |
    while read -r file; do
        pattern="$(basename "${file}")"
        if ! grep -rsqF "${pattern}" "${tmp_markup}"; then
            echo "${file}" >>"${tmp_errors}"
        fi
    done
rm -f "${tmp_markup}"

status_code=0
if test -s "${tmp_errors}"; then
    if test "${fix}" = 1; then
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
