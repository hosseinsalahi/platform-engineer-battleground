#!/bin/bash
# Auto-fixer for non-interactive CI runs.
# Polls every 2 seconds for challenge namespaces and applies solutions.
# Used by run-mock-exam.sh when stdin is not a tty.
set -Eeuo pipefail

# shellcheck disable=SC2317,SC2329
on_error() {
  local exit_code=$?
  trap - ERR
  local where=""
  where="$(caller 0 2>/dev/null || true)"
  echo "ERROR: ${0##*/}: ${where:-unknown}: ${BASH_COMMAND} (exit ${exit_code})" >&2
  exit "$exit_code"
}
trap on_error ERR

usage() {
  cat <<'USAGE_EOF'
Usage: auto-fix.sh [--interval seconds]

Watches for known challenge namespaces and applies corresponding solutions.

Options:
  --interval N   Poll interval in seconds (default: 2)
USAGE_EOF
  exit "${1:-0}"
}

INTERVAL=2
while [[ $# -gt 0 ]]; do
  case "${1:-}" in
    -h|--help) usage 0 ;;
    --interval)
      [[ -n "${2:-}" ]] || { echo "ERROR: --interval requires a value" >&2; usage 1; }
      [[ "${2}" =~ ^[0-9]+$ ]] || { echo "ERROR: --interval must be an integer (seconds)" >&2; usage 1; }
      INTERVAL="$2"; shift 2
      ;;
    --) shift; break ;;
    *) echo "Unknown option: $1" >&2; usage 1 ;;
  esac
done

echo "Auto-fixer started. Watching for broken namespaces..."
while true; do
  # Network Policy
  if kubectl get ns tenant-alpha >/dev/null 2>&1; then
    # Only apply if not already applied (optimization? No, just apply, it's idempotent)
    # But to avoid log spam, maybe check?
    # kubectl apply is relatively cheap.
    kubectl apply -f solutions/network.yaml >/dev/null 2>&1
  fi

  # Resource Quota
  if kubectl get ns team-alpha >/dev/null 2>&1; then
    kubectl apply -f solutions/quota.yaml >/dev/null 2>&1
  fi

  # PDB
  if kubectl get ns cnpe-pdb >/dev/null 2>&1; then
    kubectl apply -f solutions/pdb.yaml >/dev/null 2>&1
  fi

  # Storage Class
  if kubectl get ns cnpe-storage-test >/dev/null 2>&1; then
    kubectl apply -f solutions/storage.yaml >/dev/null 2>&1
  fi

  # Service Mesh
  if kubectl get ns cnpe-mesh-test >/dev/null 2>&1; then
    kubectl apply -f solutions/mesh.yaml >/dev/null 2>&1
  fi

  # Fault Injection
  if kubectl get ns cnpe-fault >/dev/null 2>&1; then
    kubectl apply -f solutions/fault.yaml >/dev/null 2>&1
  fi
  
  sleep "${INTERVAL}"
done
