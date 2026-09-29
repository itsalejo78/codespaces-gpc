#!/usr/bin/env bash
# Crea las VMs en GCP (desde tu PC o desde la VM master con gcloud).
set -euo pipefail

ZONE="${ZONE:-us-east1-b}"
NODES="${NODES:-10}"                  # nodos MultiPaper
NODE_TYPE="${NODE_TYPE:-e2-medium}"   # e2-micro (1 GB) NO alcanza
MASTER_TYPE="${MASTER_TYPE:-e2-standard-2}"
PROXY_TYPE="${PROXY_TYPE:-e2-small}"
IMAGE="--image-family=debian-12 --image-project=debian-cloud"

# Interno: master (35353) y nodos (25565)
gcloud compute firewall-rules create mp-internal \
  --allow=tcp:35353,tcp:25565 --source-ranges=10.128.0.0/9 \
  --target-tags=multipaper 2>/dev/null || true
# Público: SOLO el proxy Velocity
gcloud compute firewall-rules create mp-public \
  --allow=tcp:25565 --source-ranges=0.0.0.0/0 \
  --target-tags=mp-proxy 2>/dev/null || true

gcloud compute instances create mp-proxy --zone="$ZONE" \
  --machine-type="$PROXY_TYPE" $IMAGE --boot-disk-size=20GB --tags=multipaper,mp-proxy

gcloud compute instances create mp-master --zone="$ZONE" \
  --machine-type="$MASTER_TYPE" $IMAGE --boot-disk-size=50GB --tags=multipaper

for i in $(seq 1 "$NODES"); do
  gcloud compute instances create "mp-node-$i" --zone="$ZONE" \
    --machine-type="$NODE_TYPE" $IMAGE --boot-disk-size=20GB --tags=multipaper
done
