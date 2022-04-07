#!/bin/sh -e

# Wrap the `shfmt` command to provide configuration
# =============================================================================

# Usage: ./bin/shfmt.sh

# https://github.com/mvdan/sh

# POSIX locale
LC_ALL=C
export LC_ALL

fdfind -H -t f '\.sh$' --print0 |
    xargs -0 shfmt -d -p -i 4
