#!/bin/sh -e

# Find strings that should be encoded as HTML entities
# =============================================================================

# Usage: ./bin/html-entities.sh

# POSIX locale
LC_ALL=C
export LC_ALL

scan() {
    pattern="${1}"
    if (fdfind --hidden --ignore-case --print0 '\.md$' |
        xargs -0 grep --color=always -P "${pattern}"); then
        return 1
    else
        return 0
    fi
}

# Patterns
# -----------------------------------------------------------------------------

# Prefer the use of `&times;`
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# ASCII transliteration of the multiplication symbol (ignoring upper case words
# which may indicate SQL syntax)
TIMES='[a-z0-9]+ \* [a-z0-9]+'

PATTERN="(${TIMES}"

# Prefer the use of `&copy;`
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# ASCII transliteration of the copyright symbol
COPY='\([cC]\)'

PATTERN="${PATTERN}|${COPY}"

# Prefer the use of `&reg;`
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# ASCII transliteration of the registered trademark symbol
REG='\([rR]\)'

PATTERN="${PATTERN}|${REG}"

# Prefer the use of `&trade;`
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# ASCII transliteration of the trademark symbol
TRADE='\([tT][mM]\)'

PATTERN="${PATTERN}|${TRADE}"

# Prefer the use of `&check;`
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Heavy check mark (not a named entity)
CHECK='&#x2714;'

PATTERN="${PATTERN}|${CHECK}"

# Prefer the use of `&ndash;`
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Numerical ranges
DASH="[^a-zA-Z0-9-\"'\`.][[:digit:]]+-[[:digit:]]+[^a-zA-Z0-9-\"'\`.]"

PATTERN="${PATTERN}|${DASH}"

# Prefer the use of `&mdash;`
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# TODO: Decide whether (and when) to enforce spaces around an em dash

# Use of a single hyphen instead of an em dash
DASH_ALPHA_ALPHA='[a-zA-Z]+ - [a-zA-Z]+'
DASH_ALPHA_ALNUM='[a-zA-Z]+ - [[:alnum:]]+'
DASH_ALNUM_ALPHA='[[:alnum:]]+ - [a-z-A-Z]+'
DASH="(${DASH_ALPHA_ALPHA}|${DASH_ALPHA_ALNUM}|${DASH_ALNUM_ALPHA})"

# ASCII transliteration of an em dash
DASH_DASH_SPACE=' -- '
DASH_DASH_ALNUM='[[:alnum:]]+--[[:alnum:]]+'
DASH_DASH="(${DASH_DASH_SPACE}|${DASH_DASH_ALNUM})"

MDASH="(${DASH}|${DASH_DASH})"

PATTERN="${PATTERN}|${MDASH}"

# Prefer the use of `&hellip;`
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# ASCII transliteration of a horizontal ellipsis
HELLIP='\.\.\.'

PATTERN="${PATTERN}|${HELLIP})"

# Scan
# -----------------------------------------------------------------------------

scan "${PATTERN}"
