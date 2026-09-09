# Imagen Kasm — Entorno de desarrollo Python (Ubuntu 26.04)

**Imagen:** `pepesan/mi-ubuntu-resolute-kasm-python`
**Dockerfile:** `dockerfile-kasm-ubuntu-resolute-desktop-python`
**Base:** `pepesan/core-ubuntu-resolute` (experimental, ver [workspaces-core-images](https://github.com/pepesan/workspaces-core-images))

Misma imagen que [`scripts/python`](../python/README.md) pero sobre Ubuntu 26.04
"Resolute Raccoon" en lugar de 24.04 "Noble Numbat", ya que Kasm todavía no
publica una imagen base oficial para esta versión de Ubuntu.

## Contenido de la imagen

- **Python 3** (versión de Ubuntu Resolute) + `python3-venv`, `python3-pip`, `python3-dev`
- **pipx**, **uv** — gestión de entornos y paquetes Python
- Drivers de acceso a MariaDB: `python3-pymysql` y `python3-mariadb-connector`
- **PyCharm** — última release (JetBrains dejó de publicar builds separados
  de "Community" en diciembre de 2025; se instala el build unificado activo)
- **VS Code** con extensión oficial de Python (`ms-python.python`)
- **Firefox** (repositorio oficial Mozilla, sin snap)
- **Chrome** y **Chromium**
- **MariaDB** — servidor + cliente
- Repositorios de ejemplos clonados en `~/ejemplos-python` y `~/machine-learning-python`

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
./scripts/python-resolute/build.sh
./scripts/python-resolute/run.sh
./scripts/python-resolute/stop.sh
./scripts/python-resolute/destroy.sh
./scripts/python-resolute/push.sh
```

### Acceso al escritorio

Una vez arrancado con `run.sh`:

| | |
|---|---|
| URL | https://localhost:6912 |
| Usuario | `kasm_user` |
| Contraseña | `sta3war2` |

---

## Entornos Python (pip / venv / pipx / uv)

Crear un entorno virtual clásico:

```bash
python3 -m venv ~/mi-entorno
source ~/mi-entorno/bin/activate
pip install pymysql
```

Con **uv** (más rápido, gestiona también la versión de Python):

```bash
uv venv ~/mi-entorno-uv
source ~/mi-entorno-uv/bin/activate
uv pip install pymysql
```

Instalar herramientas CLI Python aisladas con **pipx**:

```bash
pipx install ruff
```

Ubuntu 26.04 marca el Python del sistema como "externally managed" (PEP 668):
instala paquetes siempre dentro de un `venv` o con `pipx`/`uv`, no con
`pip install` directo a nivel de sistema.

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

### Cadena de conexión (Python / PyMySQL)

```python
import pymysql

conn = pymysql.connect(
    host="localhost",
    user="dev",
    password="dev",
    database="desarrollo",
    charset="utf8mb4",
)
```
