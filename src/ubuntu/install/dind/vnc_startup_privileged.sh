#!/usr/bin/env bash
set -euo pipefail

# A privileged container inherits host DRM devices. KasmVNC may hang while
# probing the host render node; disable only KasmVNC's GPU renderer, leaving
# /dev/dri available to applications running inside the container.
if [[ -e /dev/dri/renderD128 ]]; then
  export VNCOPTIONS="${VNCOPTIONS:+$VNCOPTIONS }-drinode /nonexistent"
fi

exec /dockerstartup/vnc_startup_kasm.sh "$@"
