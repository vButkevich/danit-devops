#!/bin/bash
echo ":::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::"
echo "user-data"
echo "BEGIN"

apt update -y
apt install nginx -y



echo "NNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN"

TOKEN=`curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600"`

echo `curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/local-ipv4` >  /var/www/html/index.nginx-debian.html
# /etc/init.d/nginx restart

systemctl restart nginx

echo "NNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN"



echo "END"
echo ":::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::"
