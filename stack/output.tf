output "drupal_public_ip" {
  value = module.drupal.public_ip
}

output "drupal_db_user" {
  value = var.dp_name
}

output "drupal_db_password" {
  value = var.dp_password
}

output "mds_instance_ip" {
  value =  module.mds-instance.private_ip
}

output "ssh_private_key" {
  value = local.private_key_to_show
}
