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

usage() {
  cat <<'USAGE_EOF'
Usage: upgrade-cli.sh

Upgrade CLI tools installed via Homebrew (macOS) or print guidance (Linux).
USAGE_EOF
  exit "${1:-0}"
}

case "${1:-}" in
  -h|--help) usage 0 ;;
esac

OS=$(uname -s || echo unknown)

if [[ "$OS" == "Darwin" ]]; then
  if ! command -v brew >/dev/null 2>&1; then
    echo "Homebrew is required on macOS. Install: https://brew.sh" >&2
    exit 1
  fi
  echo "Updating Homebrew and upgrading CLI tools..."
  brew update || true
  FORMULAE=(kuttl kind kubernetes-cli helm istioctl tektoncd-cli argocd kyverno yq)
  for f in "${FORMULAE[@]}"; do
    echo "  -> Upgrading $f"
    brew upgrade "$f" || true
  done
  brew cleanup -s || true
  printf "\nDone. Run: just check\n"
else
  echo "Linux or other OS detected ($OS)."
  echo "If you installed via package manager, use your distro's upgrade commands (apt/dnf/yum)."
  echo "If you used this repo's binary installs, re-run: just install-cli --apply [--force]"
  echo "Alternatively, use: devbox shell"
fi
