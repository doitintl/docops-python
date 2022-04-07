#!/bin/sh -e

# Wrap the `cspell` command to provide configuration
# =============================================================================

# Usage: ./bin/cspell.sh

# https://github.com/streetsidesoftware/cspell

# POSIX locale
LC_ALL=C
export LC_ALL

fdfind --hidden --ignore-case --type f --print0 |
    xargs -0 cspell \
        --no-progress \
        --no-summary \
        --config .cspell.json
