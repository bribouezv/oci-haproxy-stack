#!/bin/bash
set -euxo pipefail

echo "==> Installing HAProxy"
apt-get update
apt-get install -y haproxy

echo "==> Writing config"
echo "${haproxy_config}" | base64 -d > /etc/haproxy/haproxy.cfg

echo "==> Enabling and starting HAProxy"
[ -s /etc/haproxy/haproxy.cfg ] && systemctl enable haproxy && systemctl restart haproxy