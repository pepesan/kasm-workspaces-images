#!/usr/bin/env bash
# Variante de install_dind.sh para bases Ubuntu 26.04 "Resolute": apt-key fue
# retirado de esa versión, así que la clave del repo de Docker se añade con
# el método moderno (keyring en /etc/apt/keyrings + "signed-by"), igual que
# ya hace este mismo repo para Firefox en dockerfile-kasm-ubuntu-resolute-desktop-python.
# Para jammy/noble se sigue usando install_dind.sh (con apt-key), sin tocar.
set -ex
ARCH=$(arch | sed 's/aarch64/arm64/g' | sed 's/x86_64/amd64/g')

# Enable Docker repo (clave vía keyring, no apt-key)
install -d -m 0755 /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc
echo "deb [arch=${ARCH} signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" > \
    /etc/apt/sources.list.d/docker.list

# Install deps
apt-get update
apt-get install -y \
    ca-certificates \
    curl \
    dbus-user-session \
    docker-buildx-plugin \
    docker-ce \
    docker-ce-cli \
    docker-compose-plugin \
    fuse-overlayfs \
    iptables \
    kmod \
    openssh-client \
    sudo \
    supervisor \
    uidmap \
    wget

# Install dind init and hacks
useradd -U dockremap
usermod -G dockremap dockremap
echo 'dockremap:165536:65536' >> /etc/subuid
echo 'dockremap:165536:65536' >> /etc/subgid
curl -o \
    /usr/local/bin/dind -L \
    https://raw.githubusercontent.com/moby/moby/master/hack/dind
chmod +x /usr/local/bin/dind
curl -o \
    /usr/local/bin/dockerd-entrypoint.sh -L \
    https://kasm-ci.s3.amazonaws.com/dockerd-entrypoint.sh
chmod +x /usr/local/bin/dockerd-entrypoint.sh
echo 'hosts: files dns' > /etc/nsswitch.conf

# En esta base el uid 1000 (el usuario real de la sesión de escritorio, el
# que ejecuta custom_startup.sh) NO se llama "kasm-user": aquí es "ubuntu"
# (heredado de la imagen base Ubuntu). "kasm-user" es una cuenta aparte
# (creada más arriba en el Dockerfile) que no es la que corre la sesión.
# Se resuelve el nombre real por uid para que este script sirva igual si
# algún día el uid 1000 se llama de otra forma.
REAL_UID1000_USER=$(getent passwd 1000 | cut -d: -f1)
usermod -aG docker "$REAL_UID1000_USER"
usermod -aG docker kasm-user 2>/dev/null || true

# custom_startup.sh (heredado de la imagen base) mantiene vivo supervisord
# haciendo "sudo supervisord -n" en bucle como el usuario de la sesión
# (uid 1000); sin NOPASSWD el escritorio no arranca (sudo pide contraseña y
# no hay terminal). No se toca la contraseña de la cuenta, solo se autoriza
# sudo sin contraseña.
echo "${REAL_UID1000_USER} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
echo 'kasm-user ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

# Cleanup
if [ -z ${SKIP_CLEAN+x} ]; then
    apt-get autoclean
    rm -rf \
        /var/lib/apt/lists/* \
        /var/tmp/* \
        /tmp/*
fi
