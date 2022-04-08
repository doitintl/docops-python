#!/bin/sh -e

# Wrap the `vale` command to provide configuration
# =============================================================================

# Usage: ./bin/vale.sh

# https://github.com/errata-ai/vale

MARKUP_PATTERN='\.(md|mdx|rst)$'

fdfind --type f --print0 "${MARKUP_PATTERN}" |
    xargs -0 vale \
        --config .vale.ini \
        --no-wrap
