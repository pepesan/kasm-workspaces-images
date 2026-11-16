#!/usr/bin/env bash
set -euo pipefail

IMAGE="pepesan/mi-ubuntu-resolute-kasm-jupyter-dind:1.3"
VNC_PASSWORD="${VNC_PASSWORD:-kasm123}"
PORT="${PORT:-6914}"
CONTAINER_NAME="${CONTAINER_NAME:-kasm-resolute-jupyter-dind-test}"

if ! docker image inspect "$IMAGE" >/dev/null 2>&1; then
  echo "No existe la imagen local $IMAGE. Ejecuta primero ./scripts/jupyter-resolute-dind/build.sh" >&2
  exit 1
fi

if docker container inspect "$CONTAINER_NAME" >/dev/null 2>&1; then
  docker rm -f "$CONTAINER_NAME"
fi

docker run -d \
  --privileged \
  --shm-size=512m \
  --name "$CONTAINER_NAME" \
  -e VNC_PW="$VNC_PASSWORD" \
  -p "${PORT}:6901" \
  "$IMAGE"

echo "Kasm listo: https://localhost:${PORT}"
echo "Usuario: kasm_user"
echo "Contraseña: ${VNC_PASSWORD}"
echo "Dentro del escritorio, abre Jupyter Notebook para iniciar el servidor."
echo "La URL local es http://127.0.0.1:8888; el token aparece en la terminal."
