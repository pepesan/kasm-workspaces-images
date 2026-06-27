# Imagen Kasm — Entorno de desarrollo Java / Ciberseguridad

**Imagen:** `pepesan/mi-ubuntu-noble-kasm`
**Dockerfile:** `dockerfile-kasm-ubuntu-noble-desktop-custom`

Imagen de escritorio sobre Ubuntu 24.04 (Kasm) con entorno completo para desarrollo Java y ciberseguridad.

## Contenido de la imagen

- **IntelliJ IDEA** (Community) — última release
- **OWASP ZAP** — última release
- **Firefox** (repositorio oficial Mozilla, sin snap)
- **Chrome** y **Chromium**
- Repositorio de ejemplos clonado en `~/spring-boot-ejemplos-basicos-ciberseguridad`

---

## Scripts

| Script       | Descripción                              |
|--------------|------------------------------------------|
| `build.sh`   | Construye la imagen Docker               |
| `run.sh`     | Arranca el contenedor                    |
| `stop.sh`    | Para el contenedor (conserva los datos)  |
| `destroy.sh` | Elimina el contenedor completamente      |
| `push.sh`    | Sube la imagen a Docker Hub              |

Ejecutar siempre desde la **raíz del proyecto**:

```bash
./scripts/java/build.sh
./scripts/java/run.sh
./scripts/java/stop.sh
./scripts/java/destroy.sh
./scripts/java/push.sh
```

### Acceso al escritorio

Una vez arrancado con `run.sh`:

| Campo      | Valor                    |
|------------|--------------------------|
| URL        | https://localhost:6901   |
| Usuario    | `kasm_user`              |
| Contraseña | `sta3war2`               |
