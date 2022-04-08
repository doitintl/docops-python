#!/bin/sh -e

# Wrap the `cspell` command to provide configuration
# =============================================================================

# Usage: ./bin/cspell.sh

# https://github.com/streetsidesoftware/cspell

fdfind --hidden --ignore-case --type f --print0 |
    xargs -0 cspell \
        --no-progress \
        --no-summary \
        --config .cspell.json
