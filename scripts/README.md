# Kasm Ubuntu Noble Desktop — Imagen Personalizada

Imagen Docker personalizada basada en **Ubuntu 24.04 (Noble)** para [Kasm Workspaces](https://kasmweb.com/), con Chrome, Chromium, Firefox, IntelliJ IDEA y herramientas de desarrollo preinstaladas.

---

## 📋 Requisitos previos

- Docker instalado y en ejecución
- Usuario con permisos de Docker (`sudo usermod -aG docker $USER`)
- Conexión a internet para descargar la imagen base y paquetes

---

## 📁 Estructura del proyecto

```
workspaces-images/
├── dockerfile-kasm-ubuntu-noble-desktop-custom   # Dockerfile principal
├── src/                                           # Scripts de instalación de Kasm
└── scripts/
    ├── build.sh    # Construye la imagen Docker
    ├── run.sh      # Lanza el contenedor localmente
    ├── push.sh     # Sube la imagen a Docker Hub
    └── destroy.sh  # Destruye el contenedor localmente
```

---

## ⚙Configuración

Edita las variables en cada script según tus necesidades:

| Variable | Descripción | Ejemplo |
|---|---|---|
| `DOCKER_USER` | Tu usuario de Docker Hub | `pepesan` |
| `IMAGE_NAME` | Nombre de la imagen | `pepesan/mi-ubuntu-noble-kasm` |
| `IMAGE_TAG` | Versión de la imagen | `1.0` |
| `BASE_TAG` | Versión de la imagen base de Kasm | `develop` |
| `USER_PASSWORD` | Contraseña del usuario y VNC | `MiClaveSegura123` |
| `PORT` | Puerto local para acceder al escritorio | `6901` |

---

## 🔨 Construir la imagen

```bash
chmod +x scripts/build.sh
./scripts/build.sh
```

Para pasar la contraseña en el momento del build sin modificar el Dockerfile:

```bash
docker build \
  --build-arg USER_PASSWORD="MiClaveSegura123" \
  --build-arg BASE_TAG="develop" \
  -t pepesan/mi-ubuntu-noble-kasm:1.0 \
  -f dockerfile-kasm-ubuntu-noble-desktop-custom \
  .
```

---

## ▶️ Lanzar el contenedor

```bash
chmod +x scripts/run.sh
./scripts/run.sh
```

O manualmente:

```bash
docker run -d \
  --name kasm-noble-test \
  --shm-size=512m \
  -e VNC_PW="MiClaveSegura123" \
  -p 6901:6901 \
  pepesan/mi-ubuntu-noble-kasm:1.0
```

---

## 🌐 Acceder al escritorio

1. Abre el navegador y ve a:

```
https://localhost:6901
```

2. Acepta el aviso de certificado SSL → **Avanzado → Continuar**

3. Introduce las credenciales:

| Campo | Valor |
|---|---|
| **Usuario** | `kasm_user` |
| **Contraseña** | El valor de `VNC_PASSWORD` en `run.sh` |

---

## 🌐 Acceder al superusuario

Dentro del contenedor accediendo por VNC, ejecuta una terminal y usa `sudo`:
```bash
sudo su -
```
La contraseña de `sudo` es la misma que `USER_PASSWORD` que usaste para construir la imagen.


## 🛠️ Comandos útiles

```bash
# Ver si el contenedor está corriendo
docker ps

# Ver logs en tiempo real
docker logs -f kasm-noble-test

# Entrar por terminal como kasm_user
docker exec -it kasm-noble-test bash

# Entrar por terminal como root
docker exec -u root -it kasm-noble-test bash

# Ver uso de recursos
docker stats kasm-noble-test

# Parar el contenedor
docker stop kasm-noble-test

# Eliminar el contenedor
docker rm -f kasm-noble-test
```

---

## 📤 Subir a Docker Hub

```bash
chmod +x scripts/push.sh
./scripts/push.sh
```

La imagen quedará disponible en:

```
https://hub.docker.com/r/pepesan/mi-ubuntu-noble-kasm
```

---

## ➕ Registrar en el panel de Kasm

1. Entra al panel de administración de Kasm
2. Ve a **Workspaces → Add Workspace**
3. Selecciona tipo **Container**
4. En **Docker Image** pon: `pepesan/mi-ubuntu-noble-kasm:1.0`
5. Configura nombre, ícono y recursos (CPU/RAM)
6. Guarda y asigna a usuarios o grupos

---

## 📦 Software incluido

| Aplicación | Descripción |
|---|---|
| Chrome | Navegador Google Chrome |
| Chromium | Navegador Chromium open source |
| Firefox | Navegador Mozilla Firefox |
| IntelliJ IDEA | IDE para desarrollo Java/Kotlin (última versión) |
| Herramientas base | curl, wget, tar y utilidades del sistema |

---

## ❗ Solución de problemas

| Síntoma | Solución |
|---|---|
| Puerto ya en uso | Cambia `PORT=6901` por otro como `6902` en `run.sh` |
| Pantalla en negro | Espera 30-60 seg, la primera vez tarda en arrancar |
| Credenciales incorrectas | Verifica que `VNC_PASSWORD` en `run.sh` coincide con `USER_PASSWORD` del `build.sh` |
| Certificado SSL | Es normal, acepta la excepción en el navegador |
| Error en `sudo` | La contraseña de `sudo` es la misma que `USER_PASSWORD` |

---

## 🔐 Seguridad

> ⚠️ No subas el Dockerfile a un repositorio público con contraseñas hardcodeadas. Usa siempre `--build-arg` para pasar datos sensibles en el momento del build.

```bash
docker build --build-arg USER_PASSWORD="TuClaveSegura" ...
```