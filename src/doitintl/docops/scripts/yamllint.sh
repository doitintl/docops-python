#!/bin/sh -e

# Wrap the `yamllint` command to provide configuration
# =============================================================================

# Usage: ./bin/yamllint.sh

# https://github.com/adrienverge/yamllint

# POSIX locale
LC_ALL=C
export LC_ALL

# ANSI formatting
RED='\x1b[1;31m'
RESET='\x1b[0m'

tmp_errors="$(mktemp)"
if ! yamllint --config-file .yamllint.yaml . >"${tmp_errors}" 2>&1; then
    sed -E "s,^(.*),${RED}\1${RESET}," <"${tmp_errors}"
    rm "${tmp_errors}"
    exit 1
fi
