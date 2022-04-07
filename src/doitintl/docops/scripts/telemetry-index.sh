#!/bin/sh -e

# Generate an `index.html` file for a directory
# =============================================================================

# Usage: ./bin/website-index.sh TARGET_DIR INDEX_FILE

# POSIX locale
LC_ALL=C
export LC_ALL

TARGET_DIR=gh-pages
INDEX_FILE=index.html

mkdir -p "${TARGET_DIR}"
cd "${TARGET_DIR}"
touch .nojekyll
printf "User-agent: *\nDisallow: /\n" >robots.txt

tmp_dir="$(mktemp -d)"

tree -h -Di --charset utf8 -H . -T 'Index' |
    sed -E 's,^[[:space:]]*</?(meta|a|br|hr|p).*,,' |
    sed -E 's,^[[:space:]]*\..*,,' |
    sed -E 's,^[[:space:]]*[[:alnum:]].*,,' |
    sed 's,<body>,<body style="font-family: monospace">,' \
        >"${tmp_dir}/tree.html"

html-minifier --minify-css --collapse-whitespace "${tmp_dir}/tree.html" |
    sed 's,<style .*></style>,,' \
        >"${tmp_dir}/minified.html"

tidy -quiet -utf8 -wrap 0 --tidy-mark no "${tmp_dir}/minified.html" |
    sed 's,<p>,<pre>\n,' |
    sed 's,</p>,\n</pre>,' |
    sed 's,<br>,,' |
    sed 's,&nbsp;, ,g' \
        >"${tmp_dir}/tidied.html"

mv "${tmp_dir}/tidied.html" "${INDEX_FILE}"

rm -rf "${tmp_dir}"
