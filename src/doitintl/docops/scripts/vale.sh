#!/bin/sh -e

# Wrap the `vale` command to provide configuration
# =============================================================================

# Usage: ./bin/vale.sh

# https://github.com/errata-ai/vale

# POSIX locale
LC_ALL=C
export LC_ALL

fdfind --hidden --ignore-case --type f --print0 '\.md$' |
    xargs -0 vale \
        --config .vale.ini \
        --minAlertLevel warning \
        --output=.vale/templates/cli.tmpl \
        --no-wrap
