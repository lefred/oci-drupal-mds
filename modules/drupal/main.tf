## DATASOURCE
# Init Script Files
data "template_file" "install_php" {
  template = file("${path.module}/scripts/install_php74.sh")

  vars = {
    mysql_version         = "${var.mysql_version}",
    user                  = "${var.vm_user}"
  }
}

data "template_file" "install_drupal" {
  template = file("${path.module}/scripts/install_drupal.sh")
}

data "template_file" "configure_local_security" {
  template = file("${path.module}/scripts/configure_local_security.sh")
}

data "template_file" "create_drupal_db" {
  template = file("${path.module}/scripts/create_drupal_db.sh")

  vars = {
    admin_password  = var.admin_password
    admin_username  = var.admin_username
    drupal_name     = var.drupal_name
    drupal_password = var.drupal_password
    drupal_schema   = var.drupal_schema
    mds_ip          = var.mds_ip
  }
}



locals {
  php_script      = "~/install_php74.sh"
  drupal_script       = "~/install_drupal.sh"
  security_script = "~/configure_local_security.sh"
  create_drupal_db    = "~/create_drupal_db.sh"
}

resource "oci_core_instance" "Drupal" {
  availability_domain = var.availability_domain
  compartment_id      = var.compartment_ocid
  display_name        = "${var.label_prefix}${var.display_name}"
  shape               = var.shape

  create_vnic_details {
    subnet_id        = var.subnet_id
    display_name     = "${var.label_prefix}${var.display_name}"
    assign_public_ip = var.assign_public_ip
    hostname_label   = var.display_name
  }

  metadata = {
    ssh_authorized_keys = var.ssh_authorized_keys
  }

  source_details {
    source_id   = var.image_id
    source_type = "image"
  }

  provisioner "file" {
    content     = data.template_file.install_php.rendered
    destination = local.php_script

    connection  {
      type        = "ssh"
      host        = self.public_ip
      agent       = false
      timeout     = "5m"
      user        = var.vm_user
      private_key = var.ssh_private_key

    }
  }

  provisioner "file" {
    content     = data.template_file.install_drupal.rendered
    destination = local.drupal_script

    connection  {
      type        = "ssh"
      host        = self.public_ip
      agent       = false
      timeout     = "5m"
      user        = var.vm_user
      private_key = var.ssh_private_key

    }
  }

  provisioner "file" {
    content     = data.template_file.configure_local_security.rendered
    destination = local.security_script

    connection  {
      type        = "ssh"
      host        = self.public_ip
      agent       = false
      timeout     = "5m"
      user        = var.vm_user
      private_key = var.ssh_private_key

    }
  }

 provisioner "file" {
    content     = data.template_file.create_drupal_db.rendered
    destination = local.create_drupal_db

    connection  {
      type        = "ssh"
      host        = self.public_ip
      agent       = false
      timeout     = "5m"
      user        = var.vm_user
      private_key = var.ssh_private_key

    }
  }


   provisioner "remote-exec" {
    connection  {
      type        = "ssh"
      host        = self.public_ip
      agent       = false
      timeout     = "5m"
      user        = var.vm_user
      private_key = var.ssh_private_key

    }
   
    inline = [
       "chmod +x ${local.php_script}",
       "sudo ${local.php_script}",
       "chmod +x ${local.drupal_script}",
       "sudo ${local.drupal_script}",
       "chmod +x ${local.security_script}",
       "sudo ${local.security_script}",
       "chmod +x ${local.create_drupal_db}",
       "sudo ${local.create_drupal_db}"
    ]

   }

  timeouts {
    create = "10m"

  }
}
