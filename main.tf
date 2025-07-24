locals {
  haproxy_config = templatefile("${path.module}/templates/haproxy.cfg.tpl", {
    backend_ips = var.haproxy_backend_ips
    https_port  = var.haproxy_https_nodeport
  })
}

data "template_cloudinit_config" "haproxy_init" {
  gzip          = false
  base64_encode = true

  part {
    filename     = "haproxy-setup.sh"
    content_type = "text/x-shellscript"
    content      = <<-EOF
      #!/bin/bash
      echo "==> Installing HAProxy"
      apt-get update
      apt-get install -y haproxy

      echo "==> Writing config"
      cat <<EOC > /etc/haproxy/haproxy.cfg
${replace(local.haproxy_config, "$", "$$")}
EOC

      echo "==> Starting HAProxy"
      systemctl enable haproxy
      systemctl restart haproxy
    EOF
  }
}

resource "oci_core_instance" "haproxy" {
  availability_domain = var.availability_domain
  compartment_id      = var.compartment_id
  shape               = var.shape

  display_name = "haproxy-instance"

  create_vnic_details {
    subnet_id        = var.subnet_id
    assign_public_ip = true
  }

  source_details {
    source_type = "image"
    source_id   = data.oci_core_images.ubuntu_latest.images[0].id
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
    user_data           = data.template_cloudinit_config.haproxy_init.rendered
  }
}
