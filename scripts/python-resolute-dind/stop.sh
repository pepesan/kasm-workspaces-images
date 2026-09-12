#!/bin/bash

set -e

CONTAINER_NAME="kasm-python-resolute-dind-test"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

if ! docker ps --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
  echo -e "${YELLOW}⚠ El contenedor ${CONTAINER_NAME} no está en ejecución${NC}"
  exit 0
fi

docker stop "${CONTAINER_NAME}"
echo -e "${GREEN}✔ Contenedor detenido: ${CONTAINER_NAME}${NC}"
