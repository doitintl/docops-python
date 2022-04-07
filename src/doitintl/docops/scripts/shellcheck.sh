#!/bin/sh -e

# Wrap the `shellcheck` command to provide configuration
# =============================================================================

# Usage: ./bin/shellcheck.sh

# https://github.com/koalaman/shellcheck

# POSIX locale
LC_ALL=C
export LC_ALL

fdfind -H -t f '\.sh$' --print0 |
    xargs -0 shellcheck
