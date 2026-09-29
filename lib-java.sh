#!/usr/bin/env bash
# Instala Temurin 25 (Minecraft 26.x requiere Java 25). Debian 12.
set -euo pipefail
sudo apt-get update
sudo apt-get install -y curl gpg git rsync ca-certificates
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://packages.adoptium.net/artifactory/api/gpg/key/public \
  | sudo gpg --dearmor -o /etc/apt/keyrings/adoptium.gpg
echo "deb [signed-by=/etc/apt/keyrings/adoptium.gpg] https://packages.adoptium.net/artifactory/deb $(. /etc/os-release; echo $VERSION_CODENAME) main" \
  | sudo tee /etc/apt/sources.list.d/adoptium.list >/dev/null
sudo apt-get update
sudo apt-get install -y temurin-25-jre
java -version
