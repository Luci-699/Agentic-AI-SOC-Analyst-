#!/usr/bin/env bash
# =============================================================================
# Wazuh Certificate Generator
# Generates all TLS certs required by the Wazuh stack before first run.
# Run this ONCE: bash infrastructure/generate-certs.sh
# Requires: docker (uses the wazuh/wazuh-certs-generator image)
# =============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CERTS_DIR="$SCRIPT_DIR/certs"

echo "============================================================"
echo " Wazuh Certificate Generator"
echo "============================================================"

# Create output directory
mkdir -p "$CERTS_DIR"

# Write config file for cert generation
cat > "$SCRIPT_DIR/certs-config.yml" <<'EOF'
nodes:
  indexer:
    - name: wazuh.indexer
      ip: "wazuh.indexer"
      
  server:
    - name: wazuh.manager
      ip: "wazuh.manager"

  dashboard:
    - name: wazuh.dashboard
      ip: "wazuh.dashboard"
EOF

echo "[1/3] Generating certificates using Wazuh cert generator..."
docker run --rm \
  -v "$SCRIPT_DIR/certs-config.yml:/config/certs.yml" \
  -v "$CERTS_DIR:/certificates" \
  wazuh/wazuh-certs-generator:0.0.1

echo "[2/3] Renaming certs to expected locations..."

# Flatten the nested structure from the generator
if [ -d "$CERTS_DIR/wazuh.indexer" ]; then
  cp "$CERTS_DIR/wazuh.indexer/wazuh.indexer.pem"     "$CERTS_DIR/"
  cp "$CERTS_DIR/wazuh.indexer/wazuh.indexer-key.pem" "$CERTS_DIR/"
fi

if [ -d "$CERTS_DIR/wazuh.manager" ]; then
  cp "$CERTS_DIR/wazuh.manager/wazuh.manager.pem"         "$CERTS_DIR/"
  cp "$CERTS_DIR/wazuh.manager/wazuh.manager-key.pem"     "$CERTS_DIR/"
fi

# Copy manager certs with alternate names used by filebeat
cp "$CERTS_DIR/wazuh.manager.pem"     "$CERTS_DIR/root-ca-manager.pem" 2>/dev/null || true

if [ -d "$CERTS_DIR/wazuh.dashboard" ]; then
  cp "$CERTS_DIR/wazuh.dashboard/wazuh.dashboard.pem"     "$CERTS_DIR/"
  cp "$CERTS_DIR/wazuh.dashboard/wazuh.dashboard-key.pem" "$CERTS_DIR/"
fi

# Admin certs (used by indexer security plugin)
if [ -d "$CERTS_DIR/admin" ]; then
  cp "$CERTS_DIR/admin/admin.pem"     "$CERTS_DIR/"
  cp "$CERTS_DIR/admin/admin-key.pem" "$CERTS_DIR/"
fi

echo "[3/3] Certificate generation complete!"
echo ""
echo "Certs saved to: $CERTS_DIR"
ls -la "$CERTS_DIR"/*.pem 2>/dev/null || echo "Note: Check output above for pem file locations"
echo ""
echo "Next step: docker-compose up -d"
