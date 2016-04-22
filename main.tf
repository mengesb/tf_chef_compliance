# Chef Compliance AWS security group
resource "aws_security_group" "chef-compliance" {
  name        = "${var.hostname}.${var.domain} security group"
  description = "Compliance server ${var.hostname}.${var.domain}"
  vpc_id      = "${var.aws_vpc_id}"
  tags        = {
    Name      = "${var.hostname}.${var.domain} security group"
  }
}
# SSH - allowed_cidrs
resource "aws_security_group_rule" "chef-compliance_allow_22_tcp_all" {
  type        = "ingress"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["${split(",", var.allowed_cidrs)}"]
  security_group_id = "${aws_security_group.chef-compliance.id}"
}
# HTTP (nginx)
resource "aws_security_group_rule" "chef-compliance_allow_80_tcp_all" {
  type        = "ingress"
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.chef-compliance.id}"
}
# HTTPS (nginx)
resource "aws_security_group_rule" "chef-compliance_allow_443_tcp_all" {
  type        = "ingress"
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.chef-compliance.id}"
}
## Chef Server -> Compliance
#resource "aws_security_group_rule" "chef-compliance_allow_all_chef-server" {
#  type        = "ingress"
#  from_port   = 0
#  to_port     = 0
#  protocol    = "-1"
#  source_security_group_id = "${var.chef_sg}"
#  security_group_id = "${aws_security_group.chef-compliance.id}"
#}
## Compliance -> Chef Server
#resource "aws_security_group_rule" "chef-server_allow_all_chef-compliance" {
#  type        = "ingress"
#  from_port   = 0
#  to_port     = 0
#  protocol    = "-1"
#  source_security_group_id = "${aws_security_group.chef-compliance.id}"
#  security_group_id = "${var.chef_sg}"
#}
# Egress: ALL
resource "aws_security_group_rule" "chef-compliance_allow_all" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.chef-compliance.id}"
}
provider "aws" {
  access_key  = "${var.aws_access_key}"
  secret_key  = "${var.aws_secret_key}"
  region      = "${var.aws_region}"
}
#
# Wait on
#
resource "null_resource" "wait_on" {
  provisioner "local-exec" {
    command = "echo Waited on ${var.wait_on} before proceeding"
  }
}
# Hack chef-server's attributes to support an compliance server
resource "template_file" "attributes-json" {
  template = "${file("${path.module}/files/attributes-json.tpl")}"
  vars {
    cert      = "/var/opt/chef-compliance/ssl/${var.hostname}.${var.domain}.crt"
    cert_key  = "/var/opt/chef-compliance/ssl/${var.hostname}.${var.domain}.key"
    domain    = "${var.domain}"
    host      = "${var.hostname}"
  }
}
#
# Compliance
#
resource "aws_instance" "chef-compliance" {
  depends_on    = ["null_resource.wait_on"]
  ami           = "${lookup(var.ami_map, "${var.ami_os}-${var.aws_region}")}"
  count         = "${var.server_count}"
  instance_type = "${var.aws_flavor}"
  associate_public_ip_address = "${var.public_ip}"
  subnet_id     = "${var.aws_subnet_id}"
  vpc_security_group_ids = ["${aws_security_group.chef-compliance.id}"]
  key_name      = "${var.aws_key_name}"
  tags = {
    Name        = "${var.hostname}.${var.domain}"
    Description = "${var.tag_description}"
  }
  root_block_device = {
    delete_on_termination = "${var.root_delete_termination}"
  }
  connection {
    user        = "${lookup(var.ami_usermap, var.ami_os)}"
    private_key = "${var.aws_private_key_file}"
    host        = "${self.public_ip}"
  }
  provisioner "local-exec" {
    command = "knife node-delete   ${var.hostname}.${var.domain} -y -c ${var.knife_rb} ; echo OK"
  }
  provisioner "local-exec" {
    command = "knife client-delete ${var.hostname}.${var.domain} -y -c ${var.knife_rb} ; echo OK"
  }
  # Handle iptables
  provisioner "remote-exec" {
    inline = [
      "sudo service iptables stop",
      "sudo chkconfig iptables off",
      "sudo ufw disable",
      "echo Say WHAT one more time"
    ]
  }
  provisioner "remote-exec" {
    inline = [
      "mkdir -p .compliance",
      "sudo mkdir -p /etc/chef-compliance /var/opt/chef-compliance/ssl",
    ]
  }
  provisioner "file" {
    source      = "${var.ssl_cert}"
    destination = ".compliance/${var.hostname}.${var.domain}.crt"
  }
  provisioner "file" {
    source      = "${var.ssl_key}"
    destination = ".compliance/${var.hostname}.${var.domain}.key"
  }
  provisioner "remote-exec" {
    inline = [
      "cat > attributes.json <<EOF",
      "${template_file.attributes-json.rendered}",
      "EOF",
      ""
    ]
  }
  provisioner "remote-exec" {
    inline = [
      "sudo mv .compliance/${var.hostname}.${var.domain}.* /var/opt/chef-compliance/ssl",
      "sudo chown -R root:root /etc/chef-compliance /var/opt/chef-compliance/ssl",
    ]
  }
  # Provision with Chef
  provisioner "chef" {
    attributes_json = "${template_file.attributes-json.rendered}"
    environment     = "_default"
    log_to_file     = "${var.log_to_file}"
    node_name       = "${aws_instance.chef-compliance.tags.Name}"
    run_list        = ["recipe[system::default]","recipe[chef-client::default]","recipe[chef-client::config]","recipe[chef-client::cron]","recipe[chef-client::delete_validation]","recipe[chef-compliance::default]"]
    server_url      = "https://${var.chef_fqdn}/organizations/${var.chef_org}"
    validation_client_name = "${var.chef_org}-validator"
    validation_key  = "${file("${var.chef_org_validator}")}"
    version         = "${var.client_version}"
  }
}

