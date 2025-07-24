variable "compartment_id" {}
variable "availability_domain" {}
variable "subnet_id" {}
variable "shape" {
default = "VM.Standard.E2.1.Micro"
}
variable "ssh_public_key" {}
variable "haproxy_backend_ips" {
  type        = string
  description = "List of backend IP addresses in the form of a comma-separated string (for example, 10.1.0.10,10.1.0.11)"
}
variable "haproxy_https_nodeport" {
  type        = number
  description = "NodePort HTTPS exposed by the ingress controller"
}