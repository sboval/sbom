#!/usr/bin/env bash
# Full SBOM + CVE scan for the v16 stack (frappe 16.27 + erpnext 16.28 + crm) and sidecars.
set -uo pipefail
OUT="sbom-v16"; mkdir -p "$OUT"
IMG="erpnext-poc-crm:v16"

echo "== syft CycloneDX SBOM =="
syft "$IMG" -o cyclonedx-json="$OUT/sbom-erpnext-crm.cdx.json" -o syft-table="$OUT/components.txt" 2>&1 | tail -2
echo "== trivy CycloneDX SBOM =="
trivy image --format cyclonedx --output "$OUT/trivy-erpnext-crm.cdx.json" "$IMG" 2>&1 | tail -1
echo "== trivy full CVE json =="
trivy image --scanners vuln --format json --output "$OUT/cve-erpnext-crm.json" "$IMG" 2>&1 | tail -1
echo "== trivy CRIT/HIGH human =="
trivy image --scanners vuln --severity CRITICAL,HIGH "$IMG" 2>&1 > "$OUT/cve-crit-high.txt"
echo "== grype second opinion =="
grype "sbom:$OUT/sbom-erpnext-crm.cdx.json" -o table 2>&1 | tail -50 > "$OUT/grype.txt"
echo "== sidecars (new versions) =="
trivy image --scanners vuln --severity CRITICAL,HIGH mariadb:11.8       2>&1 > "$OUT/cve-mariadb.txt"
trivy image --scanners vuln --severity CRITICAL,HIGH redis:7.2-alpine   2>&1 > "$OUT/cve-redis.txt"
echo "ALL_DONE components=$(grep -c . "$OUT/components.txt" 2>/dev/null)"
