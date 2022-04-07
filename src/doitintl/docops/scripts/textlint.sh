#!/bin/sh -e

# Wrap the `textlint` command to provide extended configuration
# =============================================================================

# Usage: ./bin/textlint.sh

# https://github.com/textlint/textlint

# You can disable a rule on a line-by-line basis within a file by using
# comments like this:
#
#   <!-- textlint-disable RULE -->
#   <!-- textlint-enable -->

# POSIX locale
LC_ALL=C
export LC_ALL

dry_run=0
for arg in "$@"; do
    case "${arg}" in
    -d | --dry-run)
        dry_run=1
        shift
        ;;
    -*)
        echo "ERROR: Unknown option: ${arg}"
        exit 1
        ;;
    *) ;;
    esac
done

run_fdfind() {
    fdfind -H -t f --print0 '\.md$$'
}

if test "${dry_run}" = 1; then
    run_fdfind |
        xargs -0 textlint \
            --config .textlintrc.yaml
else
    run_fdfind |
        xargs -0 textlint --fix \
            --config .textlintrc.yaml
fi
