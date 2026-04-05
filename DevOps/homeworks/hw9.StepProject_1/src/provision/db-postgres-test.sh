#!/bin/bash
set -euo pipefail
if [[ -f /vagrant/provision/lib/common.sh ]]; then
  source /vagrant/provision/lib/common.sh
else
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  source "$SCRIPT_DIR/lib/common.sh"
fi
#--------------------------------------------------------------------

DBNAME='test'
DBUSER='test'
DBPASSWORD='test2test'

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

postgres_setup_test() {
  sudo -u postgres psql <<EOF
SELECT 'CREATE DATABASE ${DBNAME}'
WHERE NOT EXISTS (
    SELECT FROM pg_database WHERE datname = '${DBNAME}'
)\gexec
EOF

  sudo -u postgres psql -d ${DBNAME} <<EOF
CREATE TABLE IF NOT EXISTS test (
    id          SERIAL PRIMARY KEY,
    created_on  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    test        VARCHAR(255)
);
EOF

  sudo -u postgres psql -c "CREATE USER ${DBUSER} WITH PASSWORD '${DBPASSWORD}' SUPERUSER;"
  sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE ${DBNAME} TO ${DBUSER};"

}

#--------------------------------------------------------------------
main() {
  require_root
  SCRIPT="DB provisioning for [Test-DB]"
  info "Start script: ${SCRIPT}"

  postgres_setup_test

  info "End script: ${SCRIPT}"
}
main "$@"
#--------------------------------------------------------------------
