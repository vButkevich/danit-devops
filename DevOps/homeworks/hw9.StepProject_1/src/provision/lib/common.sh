#!/bin/bash
set -euo pipefail
#--------------------------------------------------------------------
require_root() {
  if [[ $EUID -ne 0 ]]; then
    echo "ERROR: run as root" >&2
    exit 1
  fi
}

info() {
  local msg=${1}
  DATETIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
  echo ">>> ${DATETIMESTAMP} >>> Info: ${msg}"
}
#--------------------------------------------------------------------
install_prerequisites() {
  info "Updating repos"
  apt-get update -y >/dev/null

  for prerequisite in "${PREREQUISITES[@]}"; do
    info "Installing prerequisite: [${prerequisite}]"
    apt-get install -y "${prerequisite}" >/dev/null
  done
}
#--------------------------------------------------------------------
git_clone_repo() {
    local repo_url="${1}"
    local repo_name
    repo_name=$(basename "${repo_url}" .git)

    info "Clone repo from ${repo_url}"

    if [[ -d "${repo_name}" ]]; then
        info "Removing existing repo ${repo_name}"
        rm -rf "${repo_name}"
    fi

    git clone "${repo_url}"
}
#--------------------------------------------------------------------