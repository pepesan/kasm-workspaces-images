# Imagen Kasm Angular (Ubuntu Resolute)

**Imagen:** `pepesan/mi-ubuntu-resolute-kasm-angular:1.2`

**Dockerfile:** `dockerfile-kasm-ubuntu-resolute-desktop-angular`

**Base:** `pepesan/core-ubuntu-resolute:1.0`

Incluye Node.js, Angular CLI, pnpm, Bun, Deno, WebStorm y repositorios de ejemplo Angular y TypeScript:

- `~/ejemplos-angular-standalone-17`
- `~/ejemplos-angular-material-16`
- `~/analog-angular-17-project`
- `~/curso-typescript-twitch`
- `~/proyecto-ejemplo-vite-typescript`

## Scripts

Ejecutar desde la raíz del repositorio:

```bash
./scripts/angular-resolute/build.sh
./scripts/angular-resolute/run.sh
./scripts/angular-resolute/stop.sh
./scripts/angular-resolute/destroy.sh
./scripts/angular-resolute/push.sh
```

`push.sh` publica `1.2` y actualiza también la etiqueta `latest`. `run.sh` usa el puerto `6922`; puedes cambiarlo con `PORT`. La contraseña VNC predeterminada es `sta3war2`; puedes cambiarla con `KASM_USER_PASSWORD` antes de ejecutar el script.
