variable "vpc_id" {
  description = "Custom vpc id - leave blank for deault"
  type        = string
  default     = ""
}

variable "create_sg" {
  type        = bool
  description = "Bool for create security group"
  default     = true
}

variable "public_ports" {
  description = "List of publicly open ports"
  type        = list(number)
  default = [
    22,
    80,
    443,
    8088,
  ]
}

variable "private_ports" {
  description = "List of publicly open ports"
  type        = list(number)
  default     = []
}

variable "private_port_cidrs" {
  description = "List of CIDR blocks for private ports"
  type        = list(string)
  default     = ["172.31.0.0/16"]
}

variable "additional_security_group_ids" {
  description = "List of security groups"
  type        = list(string)
  default     = []
}

resource "aws_security_group" "this" {
  count       = var.create_sg && var.create ? 1 : 0
  vpc_id      = var.vpc_id == "" ? null : var.vpc_id
  name        = "${var.name}-sg"
  description = "Superset security group"
  tags        = var.tags
}

resource "aws_security_group_rule" "public_ports" {
  count = var.create_sg && var.create ? length(var.public_ports) : 0

  type              = "ingress"
  security_group_id = join("", aws_security_group.this.*.id)
  protocol          = "tcp"
  from_port         = var.public_ports[count.index]
  to_port           = var.public_ports[count.index]
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "private_ports" {
  count = var.create_sg && var.create ? length(var.private_ports) : 0

  type              = "ingress"
  security_group_id = join("", aws_security_group.this.*.id)
  protocol          = "tcp"
  from_port         = var.private_ports[count.index]
  to_port           = var.private_ports[count.index]
  cidr_blocks       = var.private_port_cidrs
}

resource "aws_security_group_rule" "egress" {
  count             = var.create_sg && var.create ? 1 : 0
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = join("", aws_security_group.this.*.id)
  type              = "egress"
}
