output "drupal_public_ip" {
  value = "${module.drupal.public_ip}"
}

output "drupal_db_user" {
  value = var.drupal_name
}

output "drupal_db_password" {
  value = var.drupal_password
}

output "mds_instance_ip" {
  value = "${module.mds-instance.private_ip}"
}
