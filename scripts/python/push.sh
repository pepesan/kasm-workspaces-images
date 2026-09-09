#!/bin/bash

set -e

# ============================================
# CONFIGURACIÓN - Edita estos valores
# ============================================
DOCKER_USER="pepesan"
IMAGE_NAME="${DOCKER_USER}/mi-ubuntu-noble-kasm-python"
IMAGE_TAG="1.0"
# ============================================

# Colores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${YELLOW}====================================${NC}"
echo -e "${YELLOW}  Subiendo imagen Python a Docker Hub${NC}"
echo -e "${YELLOW}====================================${NC}"
echo ""
echo -e "  Imagen: ${GREEN}${IMAGE_NAME}:${IMAGE_TAG}${NC}"
echo ""

# Verificar que la imagen existe localmente
if ! docker image inspect "${IMAGE_NAME}:${IMAGE_TAG}" &>/dev/null; then
  echo -e "${RED}✘ Imagen no encontrada: ${IMAGE_NAME}:${IMAGE_TAG}${NC}"
  echo -e "${YELLOW}  Ejecuta primero: ./scripts/python/build.sh${NC}"
  exit 1
fi

# Login en Docker Hub
echo -e "${YELLOW}► Iniciando sesión en Docker Hub...${NC}"
docker login

# Push de la imagen
echo ""
echo -e "${YELLOW}► Subiendo imagen...${NC}"
docker push "${IMAGE_NAME}:${IMAGE_TAG}"

# Tag y push como latest también
echo ""
echo -e "${YELLOW}► Etiquetando como latest...${NC}"
docker tag "${IMAGE_NAME}:${IMAGE_TAG}" "${IMAGE_NAME}:latest"
docker push "${IMAGE_NAME}:latest"

echo ""
echo -e "${GREEN}✔ Imagen subida correctamente:${NC}"
echo -e "  ${GREEN}${IMAGE_NAME}:${IMAGE_TAG}${NC}"
echo -e "  ${GREEN}${IMAGE_NAME}:latest${NC}"
echo ""
echo -e "${YELLOW}Disponible en:${NC}"
echo -e "  https://hub.docker.com/r/${DOCKER_USER}/$(echo ${IMAGE_NAME} | cut -d'/' -f2)"
