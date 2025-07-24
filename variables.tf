variable "compartment_id" {}
variable "availability_domain" {}
variable "subnet_id" {}
variable "shape" {
default = "VM.Standard.E2.1.Micro"
}
variable "ssh_public_key" {}
variable "haproxy_backend_ips" {
  description = "Liste des IPs vers lesquelles le HAProxy redirigera le trafic (nodes du cluster OKE)"
  type        = list(string)
}
variable "haproxy_node_ports" {
  description = "NodePort HTTP et HTTPS exposés par l'ingress controller"
  type = object({
    https = number
  })
}
