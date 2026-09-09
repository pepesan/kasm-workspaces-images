# Imagen Kasm — Entorno de desarrollo Java / Ciberseguridad (Ubuntu 26.04)

**Imagen:** `pepesan/mi-ubuntu-resolute-kasm`
**Dockerfile:** `dockerfile-kasm-ubuntu-resolute-desktop-custom`
**Base:** `pepesan/core-ubuntu-resolute` (experimental, ver [workspaces-core-images](https://github.com/pepesan/workspaces-core-images))

Misma imagen que [`scripts/java`](../java/README.md) pero sobre Ubuntu 26.04
"Resolute Raccoon" en lugar de 24.04 "Noble Numbat", ya que Kasm todavía no
publica una imagen base oficial para esta versión de Ubuntu.

## Contenido de la imagen

- **IntelliJ IDEA** (Community) — última release
- **OWASP ZAP** — última release
- **Firefox** (repositorio oficial Mozilla, sin snap)
- **Chrome** y **Chromium**
- Repositorio de ejemplos clonado en `~/spring-boot-ejemplos-basicos-ciberseguridad`

---

## Scripts

| Script       | Descripción                              |
|--------------|-------------------------------------------|
| `build.sh`   | Construye la imagen Docker               |
| `run.sh`     | Arranca el contenedor                    |
| `stop.sh`    | Para el contenedor (conserva los datos)  |
| `destroy.sh` | Elimina el contenedor completamente      |
| `push.sh`    | Sube la imagen a Docker Hub              |

Ejecutar siempre desde la **raíz del proyecto**:

```bash
./scripts/java-resolute/build.sh
./scripts/java-resolute/run.sh
./scripts/java-resolute/stop.sh
./scripts/java-resolute/destroy.sh
./scripts/java-resolute/push.sh
```

### Acceso al escritorio

Una vez arrancado con `run.sh`:

| Campo      | Valor                    |
|------------|--------------------------|
| URL        | https://localhost:6910   |
| Usuario    | `kasm_user`              |
| Contraseña | `sta3war2`               |
