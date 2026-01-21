#!/usr/bin/env bash
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

ok(){ printf "  \033[0;32m✓\033[0m %s\n" "$1"; }
warn(){ printf "  \033[1;33m-\033[0m %s\n" "$1"; }
die(){ printf "  \033[0;31m✗\033[0m %s\n" "$1"; exit 1; }

usage() {
  cat <<'USAGE_EOF'
Usage: check.sh

Verify required local tools are installed and usable for the battleground.
USAGE_EOF
  exit "${1:-0}"
}

case "${1:-}" in
  -h|--help) usage 0 ;;
esac

# Check Podman
command -v podman >/dev/null 2>&1 || die "podman missing (required for kind cluster)"
ok "podman $(podman --version 2>/dev/null | cut -d' ' -f3 || echo present)"

# Check Podman machine on macOS
if [[ "$(uname -s)" == "Darwin" ]]; then
  if ! podman machine list --format "{{.Running}}" 2>/dev/null | grep -q "true"; then
    die "podman machine not running (run: podman machine init && podman machine start)"
  fi
  ok "podman machine running"
fi

# Check KIND_EXPERIMENTAL_PROVIDER is set
if [[ -z "${KIND_EXPERIMENTAL_PROVIDER:-}" ]]; then
  warn "KIND_EXPERIMENTAL_PROVIDER not set (add: export KIND_EXPERIMENTAL_PROVIDER=podman)"
else
  ok "KIND_EXPERIMENTAL_PROVIDER=${KIND_EXPERIMENTAL_PROVIDER}"
fi

command -v kubectl >/dev/null 2>&1 || die "kubectl missing"
ok "kubectl $(kubectl version --client --short 2>/dev/null || echo present)"

command -v kind >/dev/null 2>&1 || die "kind missing"
ok "kind $(kind version 2>/dev/null || echo present)"

command -v helm >/dev/null 2>&1 || die "helm missing"
ok "helm $(helm version --short --client 2>/dev/null || helm version --short 2>/dev/null || echo present)"

# KUTTL kubectl plugin
kubectl kuttl version >/dev/null 2>&1 || die "KUTTL plugin missing (install from https://kuttl.dev/docs/cli.html)"
ok "kubectl kuttl available"

# Python + PyYAML for assert parsing helper
command -v python3 >/dev/null 2>&1 || die "python3 missing"
python3 - <<'PY' 2>/dev/null || die "PyYAML missing (pip install pyyaml)"
import yaml
print('ok')
PY
ok "python3 + PyYAML available"

# Optional tooling
missing=0
if command -v yq >/dev/null 2>&1; then ok "yq present"; else warn "yq not found (optional, recommended)"; missing=$((missing+1)); fi
if command -v argocd >/dev/null 2>&1; then ok "argocd present"; else warn "argocd not found (optional)"; missing=$((missing+1)); fi
if command -v kyverno >/dev/null 2>&1; then ok "kyverno present"; else warn "kyverno not found (optional)"; missing=$((missing+1)); fi
if command -v istioctl >/dev/null 2>&1; then ok "istioctl present"; else warn "istioctl not found (optional)"; missing=$((missing+1)); fi
if command -v tkn >/dev/null 2>&1; then ok "tkn present"; else warn "tkn not found (optional)"; missing=$((missing+1)); fi

echo ""
if [ "$missing" -gt 0 ]; then
  warn "Some optional CLIs are missing. You can:"
  warn "  - Run: devbox shell   # adds argocd, tkn, kyverno, istioctl"
  warn "  - Or install locally: just install-cli (macOS Homebrew)"
fi
ok "Environment checks completed"
