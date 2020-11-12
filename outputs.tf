
output "public_ip" {
  value = join("", aws_eip_association.this.*.public_ip)
}

output "instance_type" {
  value = var.instance_type
}

output "instance_id" {
  value = join("", aws_instance.this.*.id)
}

output "key_name" {
  value = var.key_name == "" ? join("", aws_key_pair.this.*.key_name) : var.key_name
}

