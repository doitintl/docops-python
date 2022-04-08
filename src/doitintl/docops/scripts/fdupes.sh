#!/bin/sh -e

# Wrap the `fdupes` command to ignore paths
# =============================================================================

# Usage: ./bin/fdupes.sh

# ANSI formatting
RED='\x1b[1;31m'
RESET='\x1b[0m'

tmp_repo_copy="$(mktemp -d)"
rsync -qa . "${tmp_repo_copy}"

script_path="$(readlink -f "${0}")"
script_dir="$(dirname "${script_path}")"
# Remove any files that are not tracked by git
echo .git >>"${tmp_repo_copy}/.gitignore"
echo .gitignore >>"${tmp_repo_copy}/.gitignore"
(cd "${tmp_repo_copy}" && "${script_dir}"/git-clean.sh >/dev/null)

tmp_errors="$(mktemp)"
fdupes --quiet --recurse --order=name --noempty --sameline "${tmp_repo_copy}" |
    sed "s,${tmp_repo_copy},.,g" |
    sed 's,^,Duplicates: ,' >>"${tmp_errors}"

status_code=0
if test -s "${tmp_errors}"; then
    printf 'Duplicate files:\n\n'
    sed -E "s,^(.*),${RED}\1${RESET}," <"${tmp_errors}"
    status_code=1
fi

rm -rf "${tmp_repo_copy}"
rm -f "${tmp_errors}"

exit "${status_code}"
