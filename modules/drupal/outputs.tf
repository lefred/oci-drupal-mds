output "id" {
  value = "${oci_core_instance.Drupal.id}"
}

output "public_ip" {
  value = "${oci_core_instance.Drupal.public_ip}"
}

output "drupal_host_name" {
  value = "${oci_core_instance.Drupal.display_name}"
}
