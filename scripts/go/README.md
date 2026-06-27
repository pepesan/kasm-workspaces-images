# Imagen Kasm — Entorno de desarrollo Go

**Imagen:** `pepesan/mi-ubuntu-noble-kasm-go`
**Dockerfile:** `dockerfile-kasm-ubuntu-noble-desktop-go`

Imagen de escritorio sobre Ubuntu 24.04 (Kasm) con entorno completo para desarrollo en Go.

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
./scripts/go/build.sh
./scripts/go/run.sh
./scripts/go/stop.sh
./scripts/go/destroy.sh
./scripts/go/push.sh
```

### Acceso al escritorio

Una vez arrancado con `run.sh`:

| | |
|---|---|
| URL | https://localhost:6902 |
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
