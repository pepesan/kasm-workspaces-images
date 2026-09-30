# Imagen Kasm — Entorno de desarrollo Java / Spring Boot Web + DinD (Ubuntu 26.04)

**Imagen:** `pepesan/mi-ubuntu-resolute-kasm-java-spring-boot-web-dev-dind`
**Dockerfile:** `dockerfile-kasm-ubuntu-resolute-desktop-java-spring-boot-web-dev-dind`
**Base:** `pepesan/core-ubuntu-resolute` (experimental, ver [workspaces-core-images](https://github.com/pepesan/workspaces-core-images))

Variante "limpia" de la imagen Java para Resolute: sin OWASP ZAP ni el enfoque
de ciberseguridad de [`scripts/resolute-java-ciberseguridad-dind`](../resolute-java-ciberseguridad-dind/README.md).
Pensada para desarrollo Java/Spring Boot normal, con Docker-in-Docker (DinD)
para poder levantar contenedores (por ejemplo, el `docker/compose.yaml` con
MariaDB + phpMyAdmin que ya viene incluido) desde dentro del propio escritorio.

## Contenido de la imagen

- **JDKs LTS** — instalados como paquetes `.deb` del repositorio oficial de
  Ubuntu 26.04 (Resolute): la build detecta dinámicamente qué paquetes
  `openjdk-XX-jdk` existen en el repo (`apt-cache search`) y los instala todos.
- **SDKMAN** — instalado en el perfil por defecto, con Maven, Gradle y la
  última versión Temurin de cada rama LTS (8, 11, 17, 21, 25); la **21** queda
  como versión por defecto (Spring Boot 3.5.x + la versión de Lombok que fija
  aún no compilan de forma fiable con JDK 25: falla en silencio, sin ningún
  error propio de Lombok — confirmado en el repo de ejemplo de esta imagen).
  Cambiar de versión en una terminal con `sdk use java <id>` (`sdk list java`
  para ver los ids instalados). Disponible en cualquier terminal
  (se comprueba en build que el bloque de SDKMAN queda en `.bashrc`, y además
  `PATH`/`JAVA_HOME` apuntan también a los binarios "current" de SDKMAN por si
  la shell no es interactiva).
- **IntelliJ IDEA** (build unificado, última release)
- **VS Code** con Java Extension Pack y extensiones de Spring Boot
- **Docker-in-Docker (DinD)** — `docker`, `docker compose`, `k3d`, `kubectl`
- **Firefox** (repositorio oficial Mozilla, sin snap), Chrome y Chromium
- Repositorio de ejemplos clonado en `~/spring-boot-3.1-api-rest-jpa-testing`
- `~/docker/compose.yaml` con **MariaDB + phpMyAdmin**, listo para
  `docker compose up -d` (no se arranca solo; requiere que el `dockerd`
  interno ya esté levantado, cosa que supervisord hace en runtime)

## MariaDB + phpMyAdmin (`~/docker/compose.yaml`)

```bash
cd ~/docker
docker compose up -d
```

| Servicio | Puerto | Notas |
|---|---|---|
| MariaDB | `3306` | usuario `dev`/`dev`, BD `desarrollo`; root `kasm` |
| phpMyAdmin | `8091` | elegido para no chocar con los puertos web típicos de Java (8080, 8081, 8443, 9090...) ni con 80/443 |

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
./scripts/java-spring-boot-web-dev-resolute-dind/build.sh
./scripts/java-spring-boot-web-dev-resolute-dind/run.sh
./scripts/java-spring-boot-web-dev-resolute-dind/stop.sh
./scripts/java-spring-boot-web-dev-resolute-dind/destroy.sh
./scripts/java-spring-boot-web-dev-resolute-dind/push.sh
```

**Antes de `push.sh`**: probar siempre primero en local con `build.sh` +
`run.sh` y verificar a mano (IntelliJ, `sdk version`, `mvn -v`, `gradle -v`,
`docker ps`, `docker compose up -d` en `~/docker`) que todo funciona.

### Acceso al escritorio

Una vez arrancado con `run.sh`:

| Campo      | Valor                    |
|------------|--------------------------|
| URL        | https://localhost:6917   |
| Usuario    | `kasm_user`              |
| Contraseña | `$KASM_USER_PASSWORD` (def. `kasm`)|
