#!/bin/sh -e

# Wrap the `vale-server` command as a headless X application
# =============================================================================

# Usage: ./bin/vale-server.sh

# POSIX locale
LC_ALL=C
export LC_ALL

USER_ID="$(id -u)"

sudo mkdir -p "/run/user/${USER_ID}"
sudo chown "${USER_ID}:${USER_ID}" "/run/user/${USER_ID}"
sudo chown "${USER_ID}" /run/xpra

XDG_RUNTIME_DIR="${HOME}/.xpra"
export XDG_RUNTIME_DIR

mkdir -p "${XDG_RUNTIME_DIR}"

RUN_CMD="$(command -v vale-server)"

get_pid() {
    pidof "${RUN_CMD}"
}
if test -n "$(get_pid)"; then
    echo "ERROR: Vale Server is already running (PID $(get_pid))"
    exit 1
fi

echo 'Vale Server is starting...'

xpra start \
    --start-child="${RUN_CMD}" \
    --exit-with-children \
    --mdns=no \
    --html=yes \
    --notifications=no \
    --webcam=no

while ! get_pid >/dev/null; do
    sleep 1
done
