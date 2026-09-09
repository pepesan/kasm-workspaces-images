#!/bin/bash

set -e

# ============================================
# CONFIGURACIÓN - Edita estos valores
# ============================================
DOCKER_USER="pepesan"
IMAGE_NAME="${DOCKER_USER}/mi-ubuntu-resolute-kasm-python"
IMAGE_TAG="1.0"
VNC_PASSWORD="sta3war2"
PORT=6912
CONTAINER_NAME="kasm-python-resolute-test"
# ============================================

# Colores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${YELLOW}==================================================${NC}"
echo -e "${YELLOW}  Lanzando contenedor Kasm Python (Resolute)     ${NC}"
echo -e "${YELLOW}==================================================${NC}"
echo ""

# Verificar que la imagen existe localmente
if ! docker image inspect "${IMAGE_NAME}:${IMAGE_TAG}" &>/dev/null; then
  echo -e "${RED}✘ Imagen no encontrada: ${IMAGE_NAME}:${IMAGE_TAG}${NC}"
  echo -e "${YELLOW}  Ejecuta primero: ./scripts/python-resolute/build.sh${NC}"
  exit 1
fi

# Eliminar contenedor anterior si existe
if docker ps -a --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
  echo -e "${YELLOW}⚠ Eliminando contenedor anterior: ${CONTAINER_NAME}${NC}"
  docker rm -f "${CONTAINER_NAME}"
fi

# Lanzar contenedor
docker run -d \
  --name "${CONTAINER_NAME}" \
  --shm-size=512m \
  -e VNC_PW="${VNC_PASSWORD}" \
  -p "${PORT}:6901" \
  "${IMAGE_NAME}:${IMAGE_TAG}"

echo ""
echo -e "${GREEN}✔ Contenedor lanzado: ${CONTAINER_NAME}${NC}"
echo ""
echo -e "  URL:        ${GREEN}https://localhost:${PORT}${NC}"
echo -e "  Usuario:    ${GREEN}kasm_user${NC}"
echo -e "  Contraseña: ${GREEN}${VNC_PASSWORD}${NC}"
echo ""
echo -e "${YELLOW}Para ver logs:${NC}"
echo -e "  docker logs -f ${CONTAINER_NAME}"
echo ""
echo -e "${YELLOW}Para detener:${NC}"
echo -e "  docker stop ${CONTAINER_NAME}"
