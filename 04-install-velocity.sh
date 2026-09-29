#!/usr/bin/env bash
# En mp-proxy. Uso: VELOCITY_JAR_URL=... ./04-install-velocity.sh
set -euo pipefail
: "${VELOCITY_JAR_URL:?descarga el jar de Velocity desde papermc.io/software/velocity}"
bash "$(dirname "$0")/lib-java.sh"

sudo useradd -r -m -d /opt/velocity velocity 2>/dev/null || true
sudo -u velocity curl -fL "$VELOCITY_JAR_URL" -o /opt/velocity/velocity.jar
# Primer arranque para generar velocity.toml y forwarding.secret
sudo -u velocity bash -c 'cd /opt/velocity && timeout 25 java -jar velocity.jar || true'

sudo tee /etc/systemd/system/velocity.service >/dev/null <<UNIT
[Unit]
Description=Velocity
After=network.target
[Service]
User=velocity
WorkingDirectory=/opt/velocity
ExecStart=/usr/bin/java -Xms512M -Xmx768M -jar velocity.jar
Restart=always
[Install]
WantedBy=multi-user.target
UNIT
sudo systemctl daemon-reload
sudo systemctl enable velocity
echo ">>> Edita /opt/velocity/velocity.toml (ver config/velocity.toml.example) y luego: sudo systemctl start velocity"
echo ">>> El secreto para los nodos está en /opt/velocity/forwarding.secret"
