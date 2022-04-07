#!/bin/sh -e

# Update the vocabulary file
# =============================================================================

# Usage: ./bin/update-vocab.sh [-d|--dry-run]

# POSIX locale
LC_ALL=C
export LC_ALL

VOCAB_FILE=".vocab.txt"

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

match_words() {
    tmp_cat="$(mktemp)"
    fdfind --hidden --ignore-case --type f |
        grep -vE "^${VOCAB_FILE}$" |
        tr '\n' '\0' |
        xargs -0 cat >"${tmp_cat}"
    while read -r word; do
        if grep -iF "${word}" "${tmp_cat}" >/dev/null; then
            echo "${word}"
        fi
    done <"${VOCAB_FILE}"
    rm -f "${tmp_cat}"
}

tmp_vocab="$(mktemp)"

match_words | awk '{print tolower($0)}' | sort | uniq >"${tmp_vocab}"

status_code=0

if test "${dry_run}" = 0; then
    cat <"${tmp_vocab}" >"${VOCAB_FILE}"
else
    diff --color=always -u \
        --label "${VOCAB_FILE}.orig" "${VOCAB_FILE}" \
        --label "${VOCAB_FILE}" "${tmp_vocab}" ||
        status_code=1
fi

rm "${tmp_vocab}"

exit "${status_code}"
