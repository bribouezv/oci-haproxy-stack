#!/bin/bash
set -euxo pipefail

echo "==> Installing HAProxy"
apt-get update
apt-get install -y haproxy iptables-persistent

echo "==> Writing config"
echo "${haproxy_config}" | base64 -d > /etc/haproxy/haproxy.cfg

echo "==> Enabling and starting HAProxy"
[ -s /etc/haproxy/haproxy.cfg ] && systemctl enable haproxy && systemctl restart haproxy

echo "==> Configuring iptables to allow port 443"
iptables -I INPUT -p tcp --dport 443 -j ACCEPT

echo "==> Saving iptables rules"
netfilter-persistent save
