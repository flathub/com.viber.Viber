#!/bin/sh
export QTWEBENGINE_DISABLE_SANDBOX=1
export TMPDIR="${XDG_CACHE_HOME}"
export FONTCONFIG_FILE=/app/etc/fonts/viber-fonts.conf

# stale single-instance lock: the app is always PID 2 in the sandbox
for lock in "${TMPDIR}"/qtsingleapp-*-lockfile; do
    [ -e "$lock" ] || continue
    flock -n "$lock" rm -f "$lock"
done

exec /app/extra/viber/Viber "$@"
