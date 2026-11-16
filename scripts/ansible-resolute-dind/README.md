# Kasm Ansible workspace — Ubuntu Resolute + DinD

**Imagen:** `pepesan/mi-ubuntu-resolute-kasm-ansible-dind:1.4`

**Base:** `pepesan/core-ubuntu-resolute:1.20`
**Dockerfile:** `dockerfile-kasm-ubuntu-resolute-ansible-dind`

Incluye Ansible, Docker-in-Docker, Google Chrome, Firefox, IntelliJ IDEA y el repositorio del curso en `~/ejemplos-ansible`. También clona `docker-twitch` en `~/docker-twitch`. El acceso directo Docker del escritorio actualiza ese repositorio con `git pull --ff-only`, muestra los laboratorios de `compose/` y lanza el Compose que se seleccione.

## Construir y arrancar

Desde la raíz del repositorio:

```bash
./scripts/ansible-resolute-dind/build.sh
./scripts/ansible-resolute-dind/run.sh
```

Acceso local de prueba:

| | |
|---|---|
| URL | `https://localhost:6921` |
| Usuario | `kasm_user` |
| Contraseña inicial | `ansiblelab` |

Se puede cambiar la contraseña VNC al arrancar:

```bash
KASM_USER_PASSWORD='otra-clave' ./scripts/ansible-resolute-dind/run.sh
```

Docker-in-Docker requiere `--privileged`. El script oculta `/dev/dri/renderD128` para evitar que KasmVNC intente usar el dispositivo DRM del host dentro del contenedor.

## Ansible contra el servidor que ejecuta Kasm

La imagen no monta el socket Docker del host. Para administrar ese servidor desde Ansible, configura un inventario con su IP/DNS alcanzable desde el workspace y utiliza SSH con un usuario del servidor que tenga los permisos necesarios. No guardes claves privadas ni contraseñas en la imagen o en el inventario del curso; usa una clave por workspace o el mecanismo de secretos que defina el entorno del curso.

La conexión al Docker host requiere privilegios elevados en el servidor. Para cursos compartidos o ejercicios destructivos, usa un host/VM de laboratorio separado y no el host de producción de Kasm.

## Scripts

| Script | Uso |
|---|---|
| `build.sh` | Construye la imagen local |
| `push.sh` | Publica el tag fijado y actualiza `latest` en Docker Hub |
| `run.sh` | Arranca Kasm en el puerto `6921` |
| `stop.sh` | Detiene el contenedor y conserva sus datos |
| `destroy.sh` | Elimina el contenedor y sus datos no persistentes |
| `launch_docker_twitch.sh` | Actualiza `docker-twitch`, muestra los Compose disponibles y lanza el seleccionado |
| `update_ejemplos_ansible.sh` | Actualiza los ejemplos con `git pull --ff-only` |

La imagen se publica como tag versionado y `latest` tras la validación del workspace. No incluyas claves privadas ni credenciales de laboratorio en la imagen.
