locals {
  haproxy_config = templatefile("${path.module}/templates/haproxy.cfg.tpl", {
    backend_ips = var.haproxy_backend_ips
    https_port  = var.haproxy_https_nodeport
  })
}

resource "oci_core_instance" "haproxy" {
  availability_domain = var.availability_domain
  compartment_id      = var.compartment_id
  shape               = var.shape

  display_name = "haproxy-instance"

  create_vnic_details {
    subnet_id         = var.subnet_id
    assign_public_ip  = true
  }

  source_details {
    source_type = "image"
    source_id   = data.oci_core_images.ubuntu_latest.images[0].id
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
    user_data           = base64encode(templatefile("${path.module}/cloud-init/haproxy.yml", {
      haproxy_config = local.haproxy_config
    }))
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
    values = ["Canonical-Ubuntu-24.04-2025.05.20-0"]
  }
}
