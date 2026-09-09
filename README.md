![Logo][logo]

## Repositorio Clonado de Kasm Workspaces

Se ha creado una nueva imagen para ser utilizada dentro del Kasm Workspaces platform.  
Esta imagen se ha creado utilizando el Workspaces Core Image de Ubuntu 24.04 y se 
ha personalizado para incluir Intellij, Firefox y OWASP Zap.
Se ha metido un repositorio de ejemplos de ciberseguridad para que los usuarios 
puedan practicar y aprender a usar las herramientas incluidas en la imagen.
Así como se ha modificado la contraseña por defecto permitir hacer sudo.

dockerfile-kasm-ubuntu-noble-desktop-custom

También se han creado unas serie de scripts para facilitar 
la creación de la imagen personalizada, su subida a Docker Hub y su 
prueba en local.

Así como las instrucciones para su uso dentro del Kasm Workspaces platform y de forma manual.

# Custom Desktop Images (Java, Go, Python)

On top of the base Kasm images, this repo builds three ready-to-use developer
desktops — one per stack — each shipped in two variants: on **Ubuntu 24.04
(Noble)**, using Kasm's official base image, and an experimental copy on
**Ubuntu 26.04 (Resolute)**, since Kasm has not published an official base
image for that Ubuntu release yet. The Resolute variants build on top of
[`pepesan/core-ubuntu-resolute`](https://hub.docker.com/r/pepesan/core-ubuntu-resolute),
produced from a fork of Kasm's own base-image build,
[`pepesan/workspaces-core-images`](https://github.com/pepesan/workspaces-core-images).

| Stack | Noble Dockerfile | Resolute Dockerfile | IDE | Extras |
|---|---|---|---|---|
| Java / security | `dockerfile-kasm-ubuntu-noble-desktop-custom` | `dockerfile-kasm-ubuntu-resolute-desktop-custom` | IntelliJ IDEA (latest) | OWASP ZAP, Firefox, example repo |
| Go | `dockerfile-kasm-ubuntu-noble-desktop-go` | `dockerfile-kasm-ubuntu-resolute-desktop-go` | GoLand (latest) | Go toolchain, MariaDB, VS Code + Go extension, example repo |
| Python | `dockerfile-kasm-ubuntu-noble-desktop-python` | `dockerfile-kasm-ubuntu-resolute-desktop-python` | PyCharm (latest) | pip/venv/pipx/uv, MariaDB drivers, VS Code + Python extension, example repos |

## JetBrains "latest" IDE downloads

Each Dockerfile fetches the latest IDE release straight from JetBrains' API
(`data.services.jetbrains.com/products/releases`) at build time, so rebuilding
later always picks up the newest version. One catch worth knowing: JetBrains
stopped publishing separate "Community Edition" builds for IntelliJ IDEA
(`code=IIC`) and PyCharm (`code=PCC`) in December 2025 — that feed is frozen at
`2025.3`. The actively maintained feed is the unified build, queried as
`code=IIU` (IntelliJ) and `code=PCP` (PyCharm); that is what these Dockerfiles
use, with an extraction glob (`idea-*`, `pycharm-*`) that doesn't assume an
edition suffix. GoLand (`code=GO`) never had a separate Community edition, so
it needed no change.

## Scripts

Each image has a matching `scripts/<stack>` folder (and `scripts/<stack>-resolute`
for the Ubuntu 26.04 variant) with the same five commands: `build.sh`, `run.sh`,
`stop.sh`, `destroy.sh`, `push.sh`. Run them from the repo root, e.g.:

```bash
./scripts/python/build.sh          # Noble, Python
./scripts/python-resolute/build.sh # Resolute, Python
```

| Folder | Image | Port (`run.sh`) |
|---|---|---|
| `scripts/java` | `pepesan/mi-ubuntu-noble-kasm` | 6901 |
| `scripts/go` | `pepesan/mi-ubuntu-noble-kasm-go` | 6902 |
| `scripts/python` | `pepesan/mi-ubuntu-noble-kasm-python` | 6903 |
| `scripts/java-resolute` | `pepesan/mi-ubuntu-resolute-kasm` | 6910 |
| `scripts/go-resolute` | `pepesan/mi-ubuntu-resolute-kasm-go` | 6911 |
| `scripts/python-resolute` | `pepesan/mi-ubuntu-resolute-kasm-python` | 6912 |

Each folder's own `README.md` has the full detail (credentials, MariaDB
connection strings, Python env tooling, etc.).

# Workspaces Images
This repository contains several example of desktop and application Workspaces images.
Administrators may leverage these images directly or use them as a starting point for their own custom images.
Each of these images is based off one of the [**Workspaces Core Images**](https://github.com/kasmtech/workspaces-core-images?utm_campaign=Github&utm_source=github) which contain the necessary wiring to work within the Kasm Workspaces platform.


For more information about building custom images please review the  [**How To Guide**](https://kasmweb.com/docs/latest/how_to/building_images.html?utm_campaign=Github&utm_source=github)

The Kasm team publishes applications and desktop images for use inside the platform. More information, including source can be found in the [**Default Images List**](https://kasmweb.com/docs/latest/guide/custom_images.html?utm_campaign=Github&utm_source=github)


# Manual Deployment

To build the provided images:

    sudo docker build -t kasmweb/firefox:dev -f dockerfile-kasm-firefox .


While these image are primarily built to run inside the Workspaces platform, they can also be executed manually.  Please note that certain functionality, such as audio, uploads, downloads, and microphone pass-through are only available within the Kasm platform.

```
sudo docker run --rm  -it --shm-size=512m -p 6901:6901 -e VNC_PW=password kasmweb/firefox:dev
```

The container is now accessible via a browser : `https://<IP>:6901`

 - **User** : `kasm_user`
 - **Password**: `password`


# About Workspaces
Kasm Workspaces is a docker container streaming platform that enables you to deliver browser-based access to desktops, applications, and web services. Kasm uses a modern DevOps approach for programmatic delivery of services via Containerized Desktop Infrastructure (CDI) technology to create on-demand, disposable, docker containers that are accessible via web browser. The rendering of the graphical-based containers is powered by the open-source project   [**KasmVNC**](https://github.com/kasmtech/KasmVNC?utm_campaign=Github&utm_source=github)

![Screenshot][Kasm_Workflow]

Kasm Workspaces was developed to meet the most demanding secure collaboration requirements that is highly scalable, customizable, and easy to maintain.  Most importantly, Kasm provides a solution, rather than a service, so it is infinitely customizable to your unique requirements and includes a developer API so that it can be integrated with, rather than replace, your existing applications and workflows. Kasm can be deployed in the cloud (Public or Private), on-premise (Including Air-Gapped Networks), or in a hybrid configuration.

# Live Demo
A self-guided on-demand demo is available at [**kasmweb.com**](https://www.kasmweb.com/demo.html?utm_campaign=Github&utm_source=github)


[logo]: https://cdn2.hubspot.net/hubfs/5856039/dockerhub/kasm_logo.png "Kasm Logo"
[Kasm_Workflow]: https://cdn2.hubspot.net/hubfs/5856039/dockerhub/kasm_workflow_960.gif "Kasm Workflow"
