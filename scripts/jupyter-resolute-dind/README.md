# Ubuntu Resolute Desktop + Jupyter + DinD

Imagen de escritorio Kasm basada en `pepesan/core-ubuntu-resolute:1.20`. Incluye Firefox, Google Chrome, Docker-in-Docker, el repositorio `docker-twitch` y Jupyter Notebook con `pandas`, `matplotlib`, `openpyxl`, `scipy` y `scikit-learn` para análisis de datos.

## Construir y probar localmente

Desde la raíz de este repositorio:

```bash
./scripts/jupyter-resolute-dind/build.sh
./scripts/jupyter-resolute-dind/run.sh
```

Abre `https://localhost:6914`, usuario `kasm_user`, contraseña `kasm123` (o configura `VNC_PASSWORD` y `PORT` al ejecutar `run.sh`). El contenedor requiere `--privileged` para DinD.

La primera conexión usa el certificado autofirmado de Kasm; acepta el aviso del navegador. Desde otro equipo, sustituye `localhost` por la IP del host Docker. En modo privilegiado, el lanzador desactiva solo el renderizador GPU de KasmVNC, sin retirar los dispositivos GPU de las aplicaciones dentro del contenedor.

En el escritorio:

- **Docker Twitch - Lanzar entorno** actualiza `~/docker-twitch` y muestra los laboratorios disponibles. También admite `~/launch_docker_twitch.sh <número|nombre>`.
- **Jupyter Notebook** inicia Notebook en el puerto 8888 y abre la terminal con el enlace y el token de acceso. La URL desde Firefox/Chrome dentro del escritorio es `http://127.0.0.1:8888`.
- El lanzador Jupyter admite un directorio alternativo: `~/start_jupyter.sh /ruta/al/proyecto`.

- Los notebooks de ejemplo de análisis de datos están en `~/docker-twitch/compose/52_jupyter_ciencia_datos/notebooks/`; empieza por `00_primeros_pasos.ipynb`.

El entorno incluye `pandas`, `matplotlib`, `openpyxl`, `scipy` y `scikit-learn`. El instalador resuelve versiones compatibles al construir la imagen.

Se pueden instalar dependencias adicionales con la versión que requieran los ejemplos. En un terminal del escritorio:

```bash
/opt/jupyter/bin/python -m pip install "nombre-paquete==version"
/opt/jupyter/bin/python -m pip install -r /ruta/requirements.txt
```

El entorno `/opt/jupyter` pertenece a `kasm-user`, por lo que no hace falta `sudo`. Desde una celda del notebook también se puede usar `%pip install nombre-paquete==version`.

Para publicar la imagen, validar primero el escritorio y ambos lanzadores y luego ejecutar:

```bash
./scripts/jupyter-resolute-dind/push.sh
```
