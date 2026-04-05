#!/bin/bash
set -euo pipefail
if [[ -f /vagrant/provision/lib/common.sh ]]; then
  source /vagrant/provision/lib/common.sh
else
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  source "$SCRIPT_DIR/lib/common.sh"
fi
#--------------------------------------------------------------------
# require_root() {
#   if [[ $EUID -ne 0 ]]; then
#     echo "ERROR: run as root" >&2
#     exit 1
#   fi
# }

# info() {
#   local msg=${1}
#   DATETIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
#   echo ">>> [${DATETIMESTAMP}]: Info: ${msg} "
# }

install_postgres_18() {
  info "Installing PostgreSQL 18"
  apt-get install -y postgresql-18 >/dev/null
}

configure_postgres_18() {
  local pg_conf="/etc/postgresql/18/main/postgresql.conf"
  local pg_hba="/etc/postgresql/18/main/pg_hba.conf"

  info "Updating postgresql.conf"
  sed -i -E "s#^[#[:space:]]*listen_addresses[[:space:]]*=.*#listen_addresses = '*'#" "$pg_conf"

  info "Ensuring pg_hba.conf contains remote access rule"
  if ! grep -q '^host all all 0.0.0.0/0 scram-sha-256$' "$pg_hba"; then
    echo 'host all all 0.0.0.0/0 scram-sha-256' >> "$pg_hba"
  fi

  info "Restarting PostgreSQL"
  systemctl restart postgresql
  systemctl enable postgresql >/dev/null 2>&1 || true
}
#--------------------------------------------------------------------
main() {
  require_root
  SCRIPT="DB provisioning for [PostgreSQL-18]"
  info "Start script: ${SCRIPT}"

  install_postgres_18
  configure_postgres_18

  info "End script: ${SCRIPT}"
}
main "$@"
#--------------------------------------------------------------------
