#!/bin/sh
export QTWEBENGINE_DISABLE_SANDBOX=1
export TMPDIR="${XDG_CACHE_HOME}"
export FONTCONFIG_FILE=/app/etc/fonts/viber-fonts.conf

# stale single-instance lock: the app is always PID 2 in the sandbox
for lock in "${TMPDIR}"/qtsingleapp-*-lockfile; do
    [ -e "$lock" ] || continue
    flock -n "$lock" rm -f "$lock"
done


# a stale WAYLAND_DISPLAY makes Qt abort, use X11 then
if [ -n "${WAYLAND_DISPLAY:-}" ] && [ -z "${QT_QPA_PLATFORM:-}" ]; then
    case "$WAYLAND_DISPLAY" in /*) wl="$WAYLAND_DISPLAY" ;; *) wl="${XDG_RUNTIME_DIR}/${WAYLAND_DISPLAY}" ;; esac
    [ -S "$wl" ] || export QT_QPA_PLATFORM=xcb
fi


exec /app/extra/viber/Viber "$@"
