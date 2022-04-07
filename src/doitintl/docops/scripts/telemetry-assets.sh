#!/bin/sh -e

# Generate a HTML contact sheet listing all PNG assets used by the docs
# =============================================================================

# Usage: ./bin/gen-assets-list.sh ASSETS_DIR

# POSIX locale
LC_ALL=C
export LC_ALL

ASSETS_DIR=gitbook/cmp/.gitbook/assets
ASSETS_HTML=gh-pages/assets.html
ASSETS_URL=https://raw.githubusercontent.com/doitintl/help/main

mkdir -p "$(dirname "${ASSETS_HTML}")"

cat >"${ASSETS_HTML}" <<EOF
<h1>Assets contact sheet</h1>
<style>
img {
    max-width: 100%;
    height: auto;
}
</style>
EOF

(cd "${ASSETS_DIR}" && fdfind --no-ignore) |
    while read -r file; do
        basename="$(basename "${file}")"
        asset_url="${ASSETS_URL}/${ASSETS_DIR}/${basename}"
        echo "<h2 id=\"${basename}\">"
        echo "  <a href=\"#${basename}\">${basename}</a>"
        echo "</h2>"
        echo "<img src=\"${asset_url}\"/>"
    done >>"${ASSETS_HTML}"
