#!/bin/sh -e

# Wrap the `markdownlint` program to provide additional checks
# =============================================================================

# Usage: ./bin/markdownlint.sh

# TODO: Check the first line (which should always be `---`)

# POSIX locale
LC_ALL=C
export LC_ALL

find_md_files() {
    fdfind -H -t f '\.md$' --print0
}

find_md_files | xargs -0 markdownlint

# Catch additional errors
search() {
    pattern="${1}"
    if (find_md_files | xargs -0 grep --color=always -E "${pattern}"); then
        return 1
    else
        return 0
    fi
}

# Try to catch broken Markdown link syntax while allowing other uses of the
# closing `]` bracket
search '[^0-9]\]\]?)[^\[( :.,]'
