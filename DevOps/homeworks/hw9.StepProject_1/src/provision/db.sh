

#!/usr/bin/env bash
set -euo pipefail

export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get install -y postgresql postgresql-contrib

systemctl enable postgresql
systemctl start postgresql

PG_CONF=$(find /etc/postgresql -name postgresql.conf | head -n 1)
PG_HBA=$(find /etc/postgresql -name pg_hba.conf | head -n 1)

if [ -z "${PG_CONF:-}" ] || [ -z "${PG_HBA:-}" ]; then
  echo "PostgreSQL config files not found"
  exit 1
fi

sed -i "s/^#listen_addresses = 'localhost'/listen_addresses = '*'/" "$PG_CONF"

if ! grep -q "host all all 0.0.0.0/0 md5" "$PG_HBA"; then
  echo "host all all 0.0.0.0/0 md5" >> "$PG_HBA"
fi

systemctl restart postgresql

sudo -u postgres psql -tc "SELECT 1 FROM pg_roles WHERE rolname='appuser'" | grep -q 1 || \
sudo -u postgres psql -c "CREATE USER appuser WITH PASSWORD 'password';"

sudo -u postgres psql -tc "SELECT 1 FROM pg_database WHERE datname='appdb'" | grep -q 1 || \
sudo -u postgres psql -c "CREATE DATABASE appdb OWNER appuser;"

echo "DB provisioning completed"