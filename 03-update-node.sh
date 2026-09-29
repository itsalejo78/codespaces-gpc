#!/usr/bin/env bash
# Lo llama GitHub Actions por SSH: actualiza plugins y reinicia el nodo
set -euo pipefail
cd /opt/multipaper/node
[ -d plugins-repo ] || sudo -u multipaper git clone "$REPO_URL" plugins-repo
sudo -u multipaper git -C plugins-repo pull
sudo -u multipaper mkdir -p plugins
sudo -u multipaper rsync -a plugins-repo/plugins/ plugins/
sudo systemctl restart multipaper-node
