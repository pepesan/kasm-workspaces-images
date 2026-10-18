# Imagen Kasm — Terminal + Docker-in-Docker (Ubuntu 26.04)

**Imagen:** `pepesan/mi-ubuntu-resolute-kasm-terminal-dind`
**Dockerfile:** `dockerfile-kasm-ubuntu-resolute-terminal-dind`
**Base:** `pepesan/core-ubuntu-resolute` (experimental, ver [workspaces-core-images](https://github.com/pepesan/workspaces-core-images))

Misma imagen que [`scripts/resolute-terminal`](../resolute-terminal/README.md)
(workspace de tipo Terminal, sin escritorio completo) pero con **Docker
instalado dentro del contenedor** (Docker-in-Docker), para poder ejecutar
`docker`/`docker compose` directamente desde esa terminal.

## Contenido de la imagen

- Terminal `xfce4-terminal` en modo single-app (arranca maximizada, sin panel)
- Docker Engine (DinD, vía `install_dind_resolute.sh`) — usuario `kasm-user`
  añadido al grupo `docker`
- `tmux` + `screen` (con `.tmux.conf` con soporte de ratón activado)
- `nano`, `dnsutils`, `zip`
- Ansible
- Repositorio de ejemplos `docker-twitch` clonado en `~/docker-twitch`
  (común a todas las imágenes DinD de este repo)

## Requisito importante: `--privileged`

Al igual que el resto de imágenes DinD de este repo, el contenedor necesita
arrancar con `--privileged` para que `dockerd` funcione dentro de él
(ya incluido en `run.sh`).

---

## Scripts

| Script | Descripción |
|---|---|
| `build.sh` | Construye la imagen Docker |
| `run.sh` | Arranca el contenedor (con `--privileged`) |
| `stop.sh` | Para el contenedor (conserva los datos) |
| `destroy.sh` | Elimina el contenedor completamente |
| `push.sh` | Sube la imagen a Docker Hub |

Ejecutar siempre desde la **raíz del proyecto**:

```bash
./scripts/resolute-terminal-dind/build.sh
./scripts/resolute-terminal-dind/run.sh
./scripts/resolute-terminal-dind/stop.sh
./scripts/resolute-terminal-dind/destroy.sh
./scripts/resolute-terminal-dind/push.sh
```

### Acceso

Una vez arrancado con `run.sh`:

| | |
|---|---|
| URL | https://localhost:6920 |
| Usuario | `kasm_user` |
| Contraseña | `sta3war2` |

### Verificar Docker dentro del contenedor

```bash
docker exec -it kasm-terminal-dind-resolute-test docker info
```
