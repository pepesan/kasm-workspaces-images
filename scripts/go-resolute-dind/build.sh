#!/bin/bash

set -e

# ============================================
# CONFIGURACIÓN - Edita estos valores
# ============================================
DOCKER_USER="pepesan"          # ← Tu username de Docker Hub
IMAGE_NAME="${DOCKER_USER}/mi-ubuntu-resolute-kasm-go-dind"
IMAGE_TAG="1.2"
BASE_TAG="1.2"
BASE_IMAGE="pepesan/core-ubuntu-resolute"
DOCKERFILE="dockerfile-kasm-ubuntu-resolute-desktop-go-dind"
# Contraseña del usuario de la imagen: NO se guarda en el repo. Exportar antes de construir:
#   export KASM_USER_PASSWORD="..."   (por defecto: kasm)
USER_PASSWORD="${KASM_USER_PASSWORD:-kasm}"
# ============================================

# Colores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${YELLOW}=================================================${NC}"
echo -e "${YELLOW}  Construyendo imagen Kasm Go (Resolute) + DinD  ${NC}"
echo -e "${YELLOW}=================================================${NC}"
echo ""
echo -e "  Imagen:     ${GREEN}${IMAGE_NAME}:${IMAGE_TAG}${NC}"
echo -e "  Base:       ${GREEN}${BASE_IMAGE}:${BASE_TAG}${NC}"
echo -e "  Dockerfile: ${GREEN}${DOCKERFILE}${NC}"
echo ""

# Ir a la raíz del proyecto (un nivel arriba de scripts/)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "${SCRIPT_DIR}/../.."

# Construir
docker build \
  --build-arg BASE_TAG="${BASE_TAG}" \
  --build-arg BASE_IMAGE="${BASE_IMAGE}" \
  --build-arg USER_PASSWORD="${USER_PASSWORD}" \
  --build-arg TOOLS_REV="$(date +%s)" \
  -t "${IMAGE_NAME}:${IMAGE_TAG}" \
  -f "${DOCKERFILE}" \
  .

echo ""
echo -e "${GREEN}✔ Imagen construida: ${IMAGE_NAME}:${IMAGE_TAG}${NC}"
