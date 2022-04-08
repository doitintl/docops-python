#!/bin/sh -e

# Wrap the `lintspaces` command to provide extended configuration
# =============================================================================

# Usage: ./bin/lintspaces.sh

# https://github.com/schorfES/node-lintspaces

tmp_fdfind="$(mktemp)"
tmp_fdfind_grep="$(mktemp)"

cleanup() {
    rm -f "${tmp_fdfind}"
    rm -f "${tmp_fdfind_grep}"
}

trap cleanup EXIT

# List files eligible for linting
fdfind --hidden --ignore-case --type f >"${tmp_fdfind}"

fdfind_lintspaces() {
    pattern="${1}"
    maxnewlines="${2}"
    # Match files
    grep -E "${pattern}" "${tmp_fdfind}" >"${tmp_fdfind_grep}"
    # Lint matched files
    tr '\n' '\0' <"${tmp_fdfind_grep}" |
        xargs -0 lintspaces \
            --editorconfig .editorconfig \
            --matchdotfiles \
            --maxnewlines "${maxnewlines}"
    # Remove matched files from the list
    combine "${tmp_fdfind}" not "${tmp_fdfind_grep}" | sponge "${tmp_fdfind}"
}

# Lint Python files
fdfind_lintspaces '\.py$' 2

# Lint remaining files
fdfind_lintspaces '.*' 1
