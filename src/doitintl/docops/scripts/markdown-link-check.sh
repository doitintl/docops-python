#!/bin/sh -e

# Wrap the `markdown-link-check` command to provide configuration
# =============================================================================

# Usage: ./bin/markdown-link-check.sh

# https://github.com/tcort/markdown-link-check

# This program has been configured (via the `.markdown-link-check.json` file)
# to ignore external links. As a result, this check only tests internal links
# and runs much faster.

# You can check external links with the `brok.sh` script, which caches its
# results (speeding up subsequent runs).

fdfind --type f --print0 '\.md$$' |
    xargs -0 markdown-link-check \
        --config .docops/markdown-link-check.json \
        --quiet \
        --retry
