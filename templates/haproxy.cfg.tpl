global
    daemon
    maxconn 256

defaults
    mode tcp
    option tcplog
    timeout connect 5000ms
    timeout client 50000ms
    timeout server 50000ms

frontend https
    bind *:443
    mode tcp
    default_backend nodes_https

backend nodes_https
    mode tcp
    balance roundrobin
%{ for ip in backend_ips ~}
    server node-${replace(ip, ".", "-")} ${ip}:${https_port} check
%{ endfor ~}
