#!/bin/sh -e

# Wrap the `imgdup2go` command to cache results
# =============================================================================

# Usage: ./bin/imgdup2go.sh ASSETS_DIR

# POSIX locale
LC_ALL=C
export LC_ALL

# ANSI formatting
RED='\x1b[1;31m'
RESET='\x1b[0m'

assets_dir="${1}"

IMGDUP2GO_LOCK=.docops/lock/imgdup2go
mkdir -p "${IMGDUP2GO_LOCK}"

ASSETS_SIG="${IMGDUP2GO_LOCK}/assets.md5sum"
ASSETS_OUT="${IMGDUP2GO_LOCK}/assets.out"

handle_exit() {
    if test -s "${ASSETS_OUT}"; then
        sed -E "s,^(.*),${RED}\1${RESET}," <"${ASSETS_OUT}"
        return 1
    fi
    return 0
}

# Reuse the output cache if the signatures match
md5sum docs/.gitbook/assets/* >"${ASSETS_SIG}.tmp"
if cmp "${ASSETS_SIG}.tmp" "${ASSETS_SIG}" >/dev/null 2>&1; then
    handle_exit
fi

# Wipe the old signature file to prevent caching
echo >"${ASSETS_SIG}"

# Generate the output cache
echo 'Processing images...'
imgdup2go -dryrun -algo diff -path "${assets_dir}" 2>/dev/null |
    grep "${assets_dir}" |
    sed -E 's,.* imgdup2go.go:[0-9]+: ,,' \
        >"${ASSETS_OUT}"

# Move the new signature file into place
mv "${ASSETS_SIG}.tmp" "${ASSETS_SIG}"

handle_exit
