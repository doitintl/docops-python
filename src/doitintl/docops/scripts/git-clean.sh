#!/bin/sh -e

# Clean any files that match the patterns in the `.gitignore` file
# =============================================================================

# Usage: ./bin/git-clean.sh

# POSIX locale
LC_ALL=C
export LC_ALL

find_ignored() {
    while read -r pattern; do
        find . -name "${pattern}" -not -path './.git/*'
    done <.gitignore
}

find_ignored | sort -n | while read -r path; do
    if ! test -e "${path}"; then
        continue
    fi
    echo "removing ${path}"
    rm -rf "${path}"
done

find . -type d -empty -delete
