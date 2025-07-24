global
    daemon
    maxconn 256

defaults
    mode http
    timeout connect 5000ms
    timeout client 50000ms
    timeout server 50000ms

frontend https
    bind *:443
    default_backend nodes_https


backend nodes_https
%{ for ip in jsondecode(backend_ips) ~}
    server node-${replace(ip, ".", "-")} ${ip}:${https_port} check ssl verify none
%{ endfor ~}
