# MultiPaper 26.2 en Google Cloud (Velocity + master + nodos)

Jugadores → **Velocity** (mp-proxy, única IP pública) → **nodos MultiPaper** ← **mp-master** (mundo + coordinación)

1. Sube este repo a GitHub y ejecuta el workflow **Compilar MultiPaper 26.2** (Actions → Run workflow).
   Genera un Release con `multipaper-*.jar` y `multipaper-master-*.jar`.
2. `scripts/00-create-vms.sh`  → crea mp-proxy, mp-master y los nodos
3. `scripts/01-install-master.sh` → en mp-master (`MASTER_JAR_URL`)
4. `scripts/04-install-velocity.sh` → en mp-proxy, edita velocity.toml (ver `config/`)
5. `scripts/02-install-node.sh` → en cada nodo (`NODE_NAME` = nombre en velocity.toml)
6. Plugins: sube a `plugins/` y `deploy.yml` los reparte (secret `GCP_SA_KEY`)

Java 25 es obligatorio (Minecraft 26.x). Comandos útiles dentro del juego: `/servers`, `/slist`, `/mpmap`.

**Aviso:** el fork que compila 26.2 es de un solo autor y su README dice que los parches de otras
versiones "se están rebasando". Si `applyPatches` falla, aún no está listo para 26.2.
