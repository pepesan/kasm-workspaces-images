#!/usr/bin/env bash
set -euo pipefail

IMAGE="pepesan/mi-ubuntu-resolute-kasm-jupyter-dind:1.3"
echo "Publicando ${IMAGE} en Docker Hub"
docker push "${IMAGE}"
