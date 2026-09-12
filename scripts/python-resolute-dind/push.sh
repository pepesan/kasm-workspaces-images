#!/bin/bash

set -e

# ============================================
# CONFIGURACIÓN - Edita estos valores
# ============================================
DOCKER_USER="pepesan"
IMAGE_NAME="${DOCKER_USER}/mi-ubuntu-resolute-kasm-python-dind"
IMAGE_TAG="1.0"
# ============================================

# Colores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${YELLOW}=========================================${NC}"
echo -e "${YELLOW}  Subiendo imagen a Docker Hub           ${NC}"
echo -e "${YELLOW}=========================================${NC}"
echo ""
echo -e "  Imagen: ${GREEN}${IMAGE_NAME}:${IMAGE_TAG}${NC}"
echo ""

if ! docker image inspect "${IMAGE_NAME}:${IMAGE_TAG}" &>/dev/null; then
  echo -e "${RED}✘ Imagen no encontrada: ${IMAGE_NAME}:${IMAGE_TAG}${NC}"
  echo -e "${YELLOW}  Ejecuta primero: ./scripts/python-resolute-dind/build.sh${NC}"
  exit 1
fi

# Requiere sesión ya iniciada en Docker Hub (docker login previo)
echo -e "${YELLOW}► Subiendo imagen...${NC}"
docker push "${IMAGE_NAME}:${IMAGE_TAG}"

echo ""
echo -e "${YELLOW}► Etiquetando como latest...${NC}"
docker tag "${IMAGE_NAME}:${IMAGE_TAG}" "${IMAGE_NAME}:latest"
docker push "${IMAGE_NAME}:latest"

echo ""
echo -e "${GREEN}✔ Imagen subida correctamente:${NC}"
echo -e "  ${GREEN}${IMAGE_NAME}:${IMAGE_TAG}${NC}"
echo -e "  ${GREEN}${IMAGE_NAME}:latest${NC}"
