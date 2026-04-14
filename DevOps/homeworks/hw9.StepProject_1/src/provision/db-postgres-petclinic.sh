#!/bin/bash
set -euo pipefail
if [[ -f /vagrant/provision/lib/common.sh ]]; then
  source /vagrant/provision/lib/common.sh
else
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  source "$SCRIPT_DIR/lib/common.sh"
fi
#--------------------------------------------------------------------

# PREREQUISITES=(
#   curl
#   ca-certificates
# )

DBNAME='petclinic'
DBUSER='appuser'
DBPASSWORD='12345678'

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

# install_prerequisities() {
#   info "Updating repos"
#   apt-get update -y >/dev/null

#   for prerequisite in "${PREREQUISITES[@]}"; do
#     info "Installing prerequisite: [${prerequisite}]"
#     apt-get install -y "${prerequisite}" >/dev/null
#   done
# }

install_postgres() {
  info "Installing postgresql-common"
  apt-get install -y postgresql-common >/dev/null

  info "Configuring official PGDG repository"
  /usr/share/postgresql-common/pgdg/apt.postgresql.org.sh
}
install_postgres18() {
  info "Installing PostgreSQL 18"
  apt-get install -y postgresql-18 >/dev/null
}

configure_postgres18() {
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

postgres_setup_petclinic() {
  info "Creating database/user if not exists"

  sudo -u postgres psql -tc "SELECT 1 FROM pg_database WHERE datname='${DBNAME}'" | grep -q 1 ||
    sudo -u postgres psql -c "CREATE DATABASE ${DBNAME};"

  sudo -u postgres psql -tc "SELECT 1 FROM pg_roles WHERE rolname='${DBUSER}'" | grep -q 1 ||
    sudo -u postgres psql -c "CREATE USER ${DBUSER} WITH PASSWORD '${DBPASSWORD}';"
  sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE ${DBNAME} TO ${DBUSER};"
  # sudo -u postgres psql -c "GRANT ALL ON SCHEMA public TO ${DBUSER};"
  # sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO ${DBUSER};"
  # sudo -u postgres psql -c "ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO ${DBUSER};"
}
#--------------------------------------------------------------------
main() {
  require_root
  SCRIPT="DB provisioning for [Petclinic-DB]"
  info "Start script: ${SCRIPT}"

  postgres_setup_petclinic

  info "End script: ${SCRIPT}"
}
main "$@"
#--------------------------------------------------------------------
