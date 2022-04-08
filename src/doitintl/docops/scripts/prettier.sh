#!/bin/sh -e

# Wrap the `prettier` command to provide configuration
# =============================================================================

# Usage: ./bin/prettier.sh

# https://github.com/prettier/prettier

fdfind --hidden --ignore-case --type f --print0 |
    xargs -0 \
        prettier --check --ignore-unknown
