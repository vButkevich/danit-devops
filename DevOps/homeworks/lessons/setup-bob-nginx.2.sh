#!/usr/bin/env bash
set -euo pipefail

id bob >/dev/null 2>&1 || { adduser --disabled-password --gecos "" bob; echo 'bob:ChangeMe123!' | chpasswd; }
usermod -aG sudo bob
cat >/home/bob/change_hostname.sh <<'EOF'
#!/usr/bin/env bash
set -e
sudo hostnamectl set-hostname ubuntu22
EOF
chown bob:bob /home/bob/change_hostname.sh
chmod 700 /home/bob/change_hostname.sh
su - bob -c /home/bob/change_hostname.sh
apt update
apt install -y nginx net-tools
systemctl enable --now nginx
systemctl status nginx --no-pager || true
netstat -tulpn