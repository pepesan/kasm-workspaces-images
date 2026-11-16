#!/usr/bin/env bash
set -euo pipefail

PROFILE_HOME=/home/kasm-default-profile
NVM_DIR="$PROFILE_HOME/.nvm"
: "${NVM_VERSION:=0.40.3}"
: "${NODE_VERSION:=26}"
: "${PNPM_VERSION:=latest}"
: "${BUN_VERSION:=latest}"
: "${DENO_VERSION:=latest}"
: "${ANGULAR_CLI_VERSION:=latest}"
: "${WEBSTORM_VERSION:=latest}"

if ! command -v curl >/dev/null 2>&1; then
  apt-get update
  apt-get install -y --no-install-recommends curl
fi
HOME="$PROFILE_HOME" NVM_DIR="$NVM_DIR" NVM_VERSION="$NVM_VERSION" \
  NODE_VERSION="$NODE_VERSION" PNPM_VERSION="$PNPM_VERSION" \
  ANGULAR_CLI_VERSION="$ANGULAR_CLI_VERSION" bash -euo pipefail -c '
    curl -fsSL "https://raw.githubusercontent.com/nvm-sh/nvm/v${NVM_VERSION}/install.sh" | bash
    . "$NVM_DIR/nvm.sh"
    nvm install "$NODE_VERSION"
    nvm alias default "$NODE_VERSION"
    npm install --global "pnpm@${PNPM_VERSION}" "@angular/cli@${ANGULAR_CLI_VERSION}"
    node --version
    npm --version
    pnpm --version
    ng version
  '
HOME="$PROFILE_HOME" BUN_INSTALL="$PROFILE_HOME/.bun" BUN_VERSION="$BUN_VERSION" bash -euo pipefail -c '
  if [ "$BUN_VERSION" = latest ]; then
    curl -fsSL https://bun.sh/install | bash
  else
    curl -fsSL https://bun.sh/install | bash -s -- "bun-v${BUN_VERSION}"
  fi
'
HOME="$PROFILE_HOME" DENO_INSTALL="$PROFILE_HOME/.deno" DENO_VERSION="$DENO_VERSION" bash -euo pipefail -c '
  if [ "$DENO_VERSION" = latest ]; then
    curl -fsSL https://deno.land/install.sh | sh -s -- -y
  else
    curl -fsSL https://deno.land/install.sh | sh -s -- -y --version "$DENO_VERSION"
  fi
'
printf '\nexport NVM_DIR="$HOME/.nvm"\n[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"\nexport PATH="$HOME/.bun/bin:$HOME/.deno/bin:$PATH"\n' \
  >> "$PROFILE_HOME/.bashrc"
PATH="$PROFILE_HOME/.bun/bin:$PROFILE_HOME/.deno/bin:$PATH"
bun --version
deno --version

mkdir -p "$PROFILE_HOME/.vscode/extensions"
HOME="$PROFILE_HOME" code --install-extension Angular.ng-template --no-sandbox \
  --extensions-dir "$PROFILE_HOME/.vscode/extensions" \
  --user-data-dir "$PROFILE_HOME/.vscode/user-data"
HOME="$PROFILE_HOME" code --install-extension AnalogJS.vscode-analog --no-sandbox \
  --extensions-dir "$PROFILE_HOME/.vscode/extensions" \
  --user-data-dir "$PROFILE_HOME/.vscode/user-data"

mkdir -p /etc/opt/chrome/policies/managed /etc/firefox/policies
cat > /etc/opt/chrome/policies/managed/angular-devtools.json <<'EOF'
{
  "ExtensionSettings": {
    "ienfalfjdbdpebioblfackkekamfmbnh": {
      "installation_mode": "force_installed",
      "update_url": "https://clients2.google.com/service/update2/crx"
    }
  }
}
EOF
cat > /etc/firefox/policies/policies.json <<'EOF'
{
  "policies": {
    "ExtensionSettings": {
      "20a9bb38-ed7c-4faf-9aaf-7c5d241fd747": {
        "installation_mode": "force_installed",
        "install_url": "https://addons.mozilla.org/firefox/downloads/latest/angular-devtools/latest.xpi"
      }
    }
  }
}
EOF

if [ "$WEBSTORM_VERSION" = latest ]; then
  WEBSTORM_FEED='https://data.services.jetbrains.com/products/releases?code=WS&latest=true&type=release'
else
  WEBSTORM_FEED="https://data.services.jetbrains.com/products/releases?code=WS&version=${WEBSTORM_VERSION}&type=release"
fi
LATEST=$(curl -fsSL "$WEBSTORM_FEED" \
  | python3 -c 'import json,sys; print(json.load(sys.stdin)["WS"][0]["downloads"]["linux"]["link"])')
test -n "$LATEST"
curl -fL "$LATEST" -o /tmp/webstorm.tar.gz
mkdir -p /opt/webstorm
tar -xzf /tmp/webstorm.tar.gz --strip-components=1 -C /opt/webstorm
ln -s /opt/webstorm/bin/webstorm.sh /usr/local/bin/webstorm
rm /tmp/webstorm.tar.gz

mkdir -p "$PROFILE_HOME/Desktop"
printf '[Desktop Entry]\nVersion=1.0\nType=Application\nName=WebStorm\nExec=/opt/webstorm/bin/webstorm.sh\nIcon=/opt/webstorm/bin/webstorm.png\nTerminal=false\nCategories=Development;IDE;\n' \
  > "$PROFILE_HOME/Desktop/webstorm.desktop"
chmod +x "$PROFILE_HOME/Desktop/webstorm.desktop"

git clone https://github.com/pepesan/ejemplos-angular-standalone-17.git "$PROFILE_HOME/ejemplos-angular-standalone-17"
git clone https://github.com/pepesan/ejemplos-angular-material-16.git "$PROFILE_HOME/ejemplos-angular-material-16"
git clone https://github.com/pepesan/analog-angular-17-project.git "$PROFILE_HOME/analog-angular-17-project"
git clone https://github.com/pepesan/curso-typescript-twitch.git "$PROFILE_HOME/curso-typescript-twitch"
git clone https://github.com/pepesan/proyecto-ejemplo-vite-typescript.git "$PROFILE_HOME/proyecto-ejemplo-vite-typescript"

chown -R 1000:0 "$PROFILE_HOME/.nvm" "$PROFILE_HOME/.bun" "$PROFILE_HOME/.deno" \
  "$PROFILE_HOME/.vscode" "$PROFILE_HOME/Desktop" \
  "$PROFILE_HOME/ejemplos-angular-standalone-17" \
  "$PROFILE_HOME/ejemplos-angular-material-16" \
  "$PROFILE_HOME/analog-angular-17-project" \
  "$PROFILE_HOME/curso-typescript-twitch" \
  "$PROFILE_HOME/proyecto-ejemplo-vite-typescript"
apt-get clean
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
