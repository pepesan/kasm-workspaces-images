# Imagen Kasm — Java / Ciberseguridad + DinD (Ubuntu 26.04)

**Imagen:** `pepesan/mi-ubuntu-resolute-kasm-java-ciberseguridad-dind`
**Dockerfile:** `dockerfile-kasm-ubuntu-resolute-desktop-java-ciberseguridad-dind`
**Base:** `pepesan/core-ubuntu-resolute` (experimental, ver [workspaces-core-images](https://github.com/pepesan/workspaces-core-images))

Misma imagen que [`scripts/java`](../java/README.md) pero sobre Ubuntu 26.04
"Resolute Raccoon" en lugar de 24.04 "Noble Numbat" (Kasm todavía no publica
una imagen base oficial para esta versión de Ubuntu), y con Docker-in-Docker
(DinD) añadido para poder levantar objetivos de prueba vulnerables junto con
las herramientas de análisis, sin depender de ningún servicio externo.

## Contenido de la imagen

- **JDKs LTS** (8/11/17/21/25, vía `.deb` oficiales de Resolute) y **SDKMAN**
  con Maven, Gradle y las mismas versiones LTS (21 por defecto)
- **IntelliJ IDEA** (build unificado) — última release
- **OWASP ZAP** — última release
- **Trivy** — última release (escáner de vulnerabilidades: imágenes,
  filesystem, IaC, dependencias; solo CLI, sin interfaz gráfica)
- **Firefox** (repositorio oficial Mozilla, sin snap), Chrome y Chromium
- **Docker-in-Docker (DinD)** — `docker`, `docker compose`
- Repositorio de ejemplos clonado en `~/spring-boot-ejemplos-basicos-ciberseguridad`
  (incluye su propio `docker/compose.yaml`, copiado a `~/docker/compose.yaml`)

## Juice Shop + SonarQube (`~/docker/compose.yaml`)

```bash
cd ~/docker
docker compose up -d
```

| Servicio    | Puerto | Notas |
|-------------|--------|-------|
| Juice Shop  | `3000` | App deliberadamente vulnerable de OWASP; no choca con el proxy de ZAP (8080) |
| SonarQube   | `9000` | Análisis estático de seguridad (SAST) del repo clonado; login inicial `admin`/`admin` |

Flujo típico de uso: levantar Juice Shop, abrir Firefox en `http://localhost:3000`
para explorarla, y apuntar OWASP ZAP contra esa misma URL para escanear/atacar
la aplicación de prueba. En paralelo, analizar el propio código del repo con
SonarQube (ver [su README](https://github.com/pepesan/spring-boot-ejemplos-basicos-ciberseguridad/blob/master/docker/README.md)
para el comando de análisis con Maven). Los datos de SonarQube se guardan
como bind-mounts en `~/spring-boot-ejemplos-basicos-ciberseguridad/docker/`,
no como volúmenes nombrados de Docker.

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
./scripts/resolute-java-ciberseguridad-dind/build.sh
./scripts/resolute-java-ciberseguridad-dind/run.sh
./scripts/resolute-java-ciberseguridad-dind/stop.sh
./scripts/resolute-java-ciberseguridad-dind/destroy.sh
./scripts/resolute-java-ciberseguridad-dind/push.sh
```

**Antes de `push.sh`**: probar siempre primero en local con `build.sh` +
`run.sh` y verificar a mano (IntelliJ, ZAP, `docker ps`, `docker compose up -d`
en `~/docker` y acceso a Juice Shop) que todo funciona.

### Acceso al escritorio

Una vez arrancado con `run.sh`:

| Campo      | Valor                    |
|------------|--------------------------|
| URL        | https://localhost:6910   |
| Usuario    | `kasm_user`              |
| Contraseña | `sta3war2`               |
