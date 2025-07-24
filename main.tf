resource "oci_core_instance" "haproxy" {
  availability_domain = var.availability_domain
  compartment_id      = var.compartment_id
  shape               = var.shape

  create_vnic_details {
    subnet_id = var.subnet_id
    assign_public_ip = true
  }

  source_details {
    source_type = "image"
    source_id = data.oci_core_images.ubuntu_latest.images[0].id
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
    user_data           = base64encode(data.template_file.cloud_init.rendered)
  }
}

data "template_file" "haproxy_config" {
  template = file("${path.module}/templates/haproxy.cfg.tpl")
  vars = {
    backend_ips = var.haproxy_backend_ips
    https_port  = var.haproxy_https_nodeport
  }
}

data "template_file" "cloud_init" {
  template = file("${path.module}/cloud-init/haproxy.yml")
  vars = {
    haproxy_config = data.template_file.haproxy_config.rendered
  }
}

data "oci_core_images" "ubuntu_latest" {
  compartment_id   = var.compartment_id
  operating_system = "Canonical Ubuntu"
  sort_by          = "TIMECREATED"
  sort_order       = "DESC"
  shape            = var.shape

  filter {
    name   = "display_name"
    values = ["Canonical-Ubuntu-24.04-*"]
  }
}