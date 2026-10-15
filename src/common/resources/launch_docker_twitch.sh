#!/usr/bin/env bash
# Lanza uno de los entornos docker compose de ~/docker-twitch/compose/<laboratorio>.
# Por defecto actualiza el repo (git pull) y, si no se indica laboratorio,
# muestra un menu interactivo con las carpetas disponibles.
#
# El laboratorio se identifica por el numero con el que empieza su carpeta
# (ej. "00_basico" -> 00, "41_zeppelin" -> 41), tanto en el menu interactivo
# como por argumento. Tambien se acepta el nombre completo de la carpeta.
#
# Uso:
#   ~/launch_docker_twitch.sh                     # git pull + menu interactivo
#   ~/launch_docker_twitch.sh 41                   # git pull + lanza 41_zeppelin
#   ~/launch_docker_twitch.sh 00                   # git pull + lanza 00_basico
#   ~/launch_docker_twitch.sh 41_zeppelin          # tambien vale el nombre completo
#   ~/launch_docker_twitch.sh 41 --no-pull         # lanza sin actualizar el repo
set -euo pipefail

REPO_DIR="$HOME/docker-twitch"
LAB_INPUT="${1:-}"
NO_PULL=false
[[ "${2:-}" == "--no-pull" ]] && NO_PULL=true

if [ ! -d "$REPO_DIR" ]; then
    echo "ERROR: no existe $REPO_DIR (el repositorio docker-twitch no esta clonado en esta imagen)" >&2
    exit 1
fi

if [ "$NO_PULL" = false ]; then
    echo ">> Actualizando ${REPO_DIR} (git pull)..."
    git -C "$REPO_DIR" pull --ff-only
else
    echo ">> --no-pull: no se actualiza el repo"
fi

mapfile -t LABS < <(find "$REPO_DIR/compose" -maxdepth 1 -mindepth 1 -type d -printf '%f\n' | sort)

if [ "${#LABS[@]}" -eq 0 ]; then
    echo "ERROR: no se encontro ningun laboratorio en $REPO_DIR/compose" >&2
    exit 1
fi

# Resuelve un numero/nombre de laboratorio a su carpeta real dentro de compose/.
# Admite: nombre completo de carpeta, o el numero inicial (con o sin ceros a
# la izquierda) con el que empieza esa carpeta.
resolve_lab() {
    local input="$1"
    local name prefix

    for name in "${LABS[@]}"; do
        [ "$name" = "$input" ] && { echo "$name"; return 0; }
    done

    if [[ "$input" =~ ^[0-9]+$ ]]; then
        for name in "${LABS[@]}"; do
            prefix="${name%%_*}"
            if [[ "$prefix" =~ ^[0-9]+$ ]] && [ "$((10#$prefix))" -eq "$((10#$input))" ]; then
                echo "$name"
                return 0
            fi
        done
    fi

    return 1
}

LAB=""
if [ -n "$LAB_INPUT" ]; then
    if ! LAB=$(resolve_lab "$LAB_INPUT"); then
        echo "ERROR: no existe ningun laboratorio '$LAB_INPUT' en $REPO_DIR/compose" >&2
        echo "Laboratorios disponibles:" >&2
        printf '   %s\n' "${LABS[@]}" >&2
        exit 1
    fi
else
    # Menu interactivo: se elige escribiendo el numero inicial del laboratorio
    # (el mismo que aparece delante de su nombre), no una posicion de lista.
    echo ""
    echo "======================================================================"
    echo " Laboratorios disponibles en docker-twitch/compose"
    echo "======================================================================"
    for name in "${LABS[@]}"; do
        printf "  %s\n" "$name"
    done
    echo ""

    while true; do
        read -rp "Escribe el numero del laboratorio (ej. 41) o Ctrl+C para cancelar: " CHOICE
        if LAB=$(resolve_lab "$CHOICE"); then
            break
        fi
        echo "Opcion no valida, intentalo de nuevo."
    done
fi

LAB_DIR="$REPO_DIR/compose/$LAB"

cd "$LAB_DIR"

if [ -x ./00_init.sh ] && [ ! -d volumes ]; then
    echo ">> Primer arranque de '$LAB': ejecutando 00_init.sh..."
    ./00_init.sh
fi

if [ -x ./01_launch_compose.sh ]; then
    ./01_launch_compose.sh
else
    docker compose up -d
fi

echo ""
echo "OK Entorno '$LAB' lanzado (en $LAB_DIR)."
echo ""
echo ">> Puertos publicados por este laboratorio:"
grep -oP '^\s*-\s*"?[0-9]+:[0-9]+"?' compose.yaml 2>/dev/null | sed 's/^/   /' || echo "   (no se encontraron mapeos de puerto en compose.yaml)"
echo ""
read -rp "Pulsa Enter para cerrar esta terminal..." _ || true
