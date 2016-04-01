# Outputs
output "fqdn" {
  value = "${aws_instance.chef-compliance.tags.Name}"
}
output "private_ip" {
  value = "${aws_instance.chef-compliance.private_ip}"
}
output "public_ip" {
  value = "${aws_instance.chef-compliance.public_ip}"
}
output "security_group_id" {
  value = "${aws_security_group.chef-compliance.id}"
}

