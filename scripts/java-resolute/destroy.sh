#!/bin/bash

set -e

CONTAINER_NAME="kasm-resolute-test"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

if ! docker ps -a --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
  echo -e "${YELLOW}⚠ El contenedor ${CONTAINER_NAME} no existe${NC}"
  exit 0
fi

docker rm -f "${CONTAINER_NAME}"
echo -e "${GREEN}✔ Contenedor eliminado: ${CONTAINER_NAME}${NC}"
