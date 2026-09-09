# Imagen Kasm — Entorno de desarrollo Go (Ubuntu 26.04)

**Imagen:** `pepesan/mi-ubuntu-resolute-kasm-go`
**Dockerfile:** `dockerfile-kasm-ubuntu-resolute-desktop-go`
**Base:** `pepesan/core-ubuntu-resolute` (experimental, ver [workspaces-core-images](https://github.com/pepesan/workspaces-core-images))

Misma imagen que [`scripts/go`](../go/README.md) pero sobre Ubuntu 26.04
"Resolute Raccoon" en lugar de 24.04 "Noble Numbat", ya que Kasm todavía no
publica una imagen base oficial para esta versión de Ubuntu.

## Contenido de la imagen

- **Go** — última versión estable (descargada de go.dev/dl)
- **VS Code** con extensión oficial de Go (`golang.go`)
- **GoLand** (JetBrains) — última release
- **Firefox** (repositorio oficial Mozilla, sin snap)
- **MariaDB** — servidor + cliente
- Repositorio de ejemplos clonado en `~/ejemplos-go-2026`

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
./scripts/go-resolute/build.sh
./scripts/go-resolute/run.sh
./scripts/go-resolute/stop.sh
./scripts/go-resolute/destroy.sh
./scripts/go-resolute/push.sh
```

### Acceso al escritorio

Una vez arrancado con `run.sh`:

| | |
|---|---|
| URL | https://localhost:6911 |
| Usuario | `kasm_user` |
| Contraseña | `sta3war2` |

---

## MariaDB

### Arranque

MariaDB se inicia automáticamente al arrancar el contenedor vía supervisord.
Si no estuviera activo, arrancarlo manualmente:

```bash
sudo service mariadb start
```

Verificar estado:

```bash
sudo supervisorctl status
```

### Conexión

**Usuario de desarrollo** (BD `desarrollo`):
```bash
mysql -u dev -pdev desarrollo
```

**Root:**
```bash
mysql -u root -pkasm
```

### Credenciales

| Rol | Usuario | Contraseña | Base de datos |
|---|---|---|---|
| Administrador | `root` | `kasm` | — |
| Desarrollo | `dev` | `dev` | `desarrollo` |

### Cadena de conexión (Go)

```
dev:dev@tcp(localhost:3306)/desarrollo?charset=utf8mb4&parseTime=True
```

---

## Variables de entorno Go

| Variable | Valor |
|---|---|
| `GOROOT` | `/usr/local/go` |
| `GOPATH` | `/home/kasm-user/go` |
| `PATH` | incluye `/usr/local/go/bin` y `/home/kasm-user/go/bin` |
