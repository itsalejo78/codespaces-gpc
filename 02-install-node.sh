#!/usr/bin/env bash
# En cada nodo:
#   MASTER_IP=10.142.0.2 NODE_NAME=mp-node-1 SERVER_JAR_URL=... VELOCITY_SECRET=... ./02-install-node.sh
# NODE_NAME debe ser IGUAL al nombre del servidor en velocity.toml.
set -euo pipefail
: "${MASTER_IP:?IP interna del master}"
: "${NODE_NAME:?ej. mp-node-1}"
: "${SERVER_JAR_URL:?URL del multipaper.jar de tu GitHub Release}"
: "${VELOCITY_SECRET:?mismo contenido que forwarding.secret de Velocity}"
bash "$(dirname "$0")/lib-java.sh"

sudo useradd -r -m -d /opt/multipaper multipaper 2>/dev/null || true
D=/opt/multipaper/node
sudo -u multipaper mkdir -p $D/config
sudo -u multipaper curl -fL "$SERVER_JAR_URL" -o $D/server.jar
echo "eula=true" | sudo -u multipaper tee $D/eula.txt >/dev/null
printf 'online-mode=false\nserver-port=25565\n' | sudo -u multipaper tee $D/server.properties >/dev/null

# Velocity modern forwarding
sudo -u multipaper tee $D/config/paper-global.yml >/dev/null <<YML
proxies:
  velocity:
    enabled: true
    online-mode: true
    secret: ${VELOCITY_SECRET}
YML

# Los ajustes de MultiPaper se pasan por -D (así no dependes del multipaper.yml generado)
sudo tee /etc/systemd/system/multipaper-node.service >/dev/null <<UNIT
[Unit]
Description=MultiPaper Node
After=network.target
[Service]
User=multipaper
WorkingDirectory=$D
ExecStart=/usr/bin/java -Xms1G -Xmx1500M \
  -DbungeecordName=${NODE_NAME} \
  -DmultipaperMasterAddress=${MASTER_IP}:35353 \
  -jar server.jar nogui
Restart=always
[Install]
WantedBy=multi-user.target
UNIT
sudo systemctl daemon-reload
sudo systemctl enable --now multipaper-node
