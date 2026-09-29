#!/usr/bin/env bash
# En mp-master. MASTER_JAR_URL = jar de MultiPaper-Master de TU release (ver build.yml)
set -euo pipefail
: "${MASTER_JAR_URL:?URL del multipaper-master.jar de tu GitHub Release}"
bash "$(dirname "$0")/lib-java.sh"

sudo useradd -r -m -d /opt/multipaper multipaper 2>/dev/null || true
sudo -u multipaper mkdir -p /opt/multipaper/master
sudo -u multipaper curl -fL "$MASTER_JAR_URL" -o /opt/multipaper/master/master.jar

sudo tee /etc/systemd/system/multipaper-master.service >/dev/null <<UNIT
[Unit]
Description=MultiPaper Master
After=network.target
[Service]
User=multipaper
WorkingDirectory=/opt/multipaper/master
ExecStart=/usr/bin/java -Xms1G -Xmx3G -jar master.jar 35353
Restart=always
[Install]
WantedBy=multi-user.target
UNIT
sudo systemctl daemon-reload
sudo systemctl enable --now multipaper-master
