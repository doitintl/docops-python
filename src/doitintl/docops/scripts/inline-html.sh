#!/bin/sh -e

# Find inline HTML that should be Markdown
# =============================================================================

# Usage: ./bin/inline-html.sh

# POSIX locale
LC_ALL=C
export LC_ALL

scan() {
    pattern="${1}"
    if (fdfind --hidden --ignore-case --print0 '\.md$' |
        xargs -0 grep --color=always -Pi "${pattern}"); then
        return 1
    else
        return 0
    fi
}

tag_pattern() {
    name="${1}"
    echo "(<${name}>|<${name} ([^>]*>)?|</${name}>)"
}

P="$(tag_pattern p)"
A="$(tag_pattern a)"
I="$(tag_pattern i)"
B="$(tag_pattern b)"
STRONG="$(tag_pattern strong)"
IMG="$(tag_pattern img)"
CODE="$(tag_pattern code)"
PRE="$(tag_pattern pre)"

PATTERN="(${P}|${A}|${I}|${B}|${STRONG}|${IMG}|${CODE}|${PRE})"

scan "${PATTERN}"
