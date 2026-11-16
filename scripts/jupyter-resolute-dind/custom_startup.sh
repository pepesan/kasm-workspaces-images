#!/usr/bin/env bash
set -euo pipefail

# Kasm 1.20 passes --tail-log to the custom startup hook. The shared DinD hook
# parses only its own flags, so discard this entrypoint argument before delegating.
if [[ "${1:-}" == "--tail-log" ]]; then
  shift
fi

exec /dockerstartup/custom_startup_dind.sh "$@"
