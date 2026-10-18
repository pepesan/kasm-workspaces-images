# Imagen Kasm — Terminal (Ubuntu 26.04)

**Imagen:** `pepesan/mi-ubuntu-resolute-kasm-terminal`
**Dockerfile:** `dockerfile-kasm-ubuntu-resolute-terminal`
**Base:** `pepesan/core-ubuntu-resolute` (experimental, ver [workspaces-core-images](https://github.com/pepesan/workspaces-core-images))

Workspace de tipo **Terminal**: en vez de un escritorio completo, el navegador
muestra únicamente una ventana `xfce4-terminal` maximizada a pantalla completa
(sin panel, sin barra de tareas). Pensado para acceso rápido a una shell
aislada y efímera sobre Ubuntu 26.04 "Resolute Raccoon", sin el peso de un
entorno de escritorio completo.

No incluye Docker-in-Docker. Para esa variante ver
[`scripts/resolute-terminal-dind`](../resolute-terminal-dind/README.md).

## Contenido de la imagen

- Terminal `xfce4-terminal` en modo single-app (arranca maximizada, sin panel)
- `tmux` + `screen` (con `.tmux.conf` con soporte de ratón activado)
- `nano`, `dnsutils`, `zip`
- Ansible
- Terraform

---

## Scripts

| Script | Descripción |
|---|---|
| `build.sh` | Construye la imagen Docker |
| `run.sh` | Arranca el contenedor |
| `stop.sh` | Para el contenedor (conserva los datos) |
| `destroy.sh` | Elimina el contenedor completamente |
| `push.sh` | Sube la imagen a Docker Hub |

Ejecutar siempre desde la **raíz del proyecto**:

```bash
./scripts/resolute-terminal/build.sh
./scripts/resolute-terminal/run.sh
./scripts/resolute-terminal/stop.sh
./scripts/resolute-terminal/destroy.sh
./scripts/resolute-terminal/push.sh
```

### Acceso

Una vez arrancado con `run.sh`:

| | |
|---|---|
| URL | https://localhost:6919 |
| Usuario | `kasm_user` |
| Contraseña | `sta3war2` |
