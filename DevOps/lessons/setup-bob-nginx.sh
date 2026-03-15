#!/usr/bin/env bash
set -euo pipefail

USERNAME="bob"
HOSTNAME_NEW="ubuntu22"
USER_HOME="/home/${USERNAME}"
SCRIPT_PATH="${USER_HOME}/change_hostname.sh"

echo "===> 1. Create user if not exists"
if id "$USERNAME" >/dev/null 2>&1; then
    echo "User $USERNAME already exists"
else
    adduser --disabled-password --gecos "" "$USERNAME"
    echo "${USERNAME}:ChangeMe123!" | chpasswd
    echo "User $USERNAME created with temporary password: ChangeMe123!"
fi

echo "===> 2. Add user to sudo group"
usermod -aG sudo "$USERNAME"

echo "===> 3. Create hostname change script"
cat > "$SCRIPT_PATH" <<EOF
#!/usr/bin/env bash
set -e
sudo hostnamectl set-hostname ${HOSTNAME_NEW}
echo "Hostname changed to: \$(hostnamectl --static)"
EOF

echo "===> 4. Set owner and permissions"
chown "${USERNAME}:${USERNAME}" "$SCRIPT_PATH"
chmod 700 "$SCRIPT_PATH"

echo "===> 5. Run script as bob"
su - "$USERNAME" -c "$SCRIPT_PATH"

echo "===> 6. Install nginx"
apt update
apt install -y nginx

echo "===> 7. Enable and start nginx"
systemctl enable nginx
systemctl restart nginx

echo "===> 8. Check nginx status"
systemctl --no-pager --full status nginx || true

echo "===> 9. Check open ports"
if command -v netstat >/dev/null 2>&1; then
    netstat -tulpn
else
    echo "netstat not found, installing net-tools..."
    apt install -y net-tools
    netstat -tulpn
fi

echo "===> 10. Summary"
echo "User: $USERNAME"
echo "Groups:"
id "$USERNAME"
echo "Hostname now: $(hostnamectl --static)"
echo "Script permissions:"
ls -l "$SCRIPT_PATH"

echo
echo "Done."
echo "Recommended next steps:"
echo "1. reboot"
echo "2. login as: $USERNAME"