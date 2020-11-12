#####
# ec2
#####
variable "monitoring" {
  description = "Boolean for cloudwatch"
  type        = bool
  default     = false
}

variable "root_volume_size" {
  description = "Root volume size"
  type        = number
  default     = 8
}

variable "root_volume_type" {
  description = ""
  type        = string
  default     = "gp2"
}

variable "root_iops" {
  description = ""
  type        = string
  default     = null
}

variable "instance_type" {
  description = "Instance type"
  type        = string
  default     = "t3.small"
}

variable "key_name" {
  description = "The key pair to import - leave blank to generate new keypair from pub/priv ssh key path"
  type        = string
  default     = ""
}

variable "public_key_path" {
  description = "The path to the public ssh key"
  type        = string
}

variable "private_key_path" {
  description = "The path to the private ssh key"
  type        = string
}

variable "subnet_id" {
  description = "The id of the subnet"
  type        = string
  default     = ""
}

variable "ami" {
  description = "AMI to use as base image - blank for ubuntu"
  type        = string
  default     = ""
}

module "ami" {
  source = "github.com/insight-infrastructure/terraform-aws-ami.git?ref=v0.1.0"
}

resource "aws_key_pair" "this" {
  count      = var.public_key_path != "" && var.create ? 1 : 0
  public_key = file(pathexpand(var.public_key_path))
  tags       = merge({ Name = local.name_suffix }, var.tags)
}

resource "aws_eip" "this" {
  count = var.create ? 1 : 0
  tags  = merge({ Name = local.name_suffix }, var.tags)
}

resource "aws_eip_association" "this" {
  count       = var.create ? 1 : 0
  instance_id = join("", aws_instance.this.*.id)
  public_ip   = join("", aws_eip.this.*.public_ip)
}

resource "aws_instance" "this" {
  count         = var.create ? 1 : 0
  ami           = var.ami == "" ? module.ami.ubuntu_1804_ami_id : var.ami
  instance_type = var.instance_type

  root_block_device {
    volume_size = var.root_volume_size
    volume_type = var.root_volume_type
    iops        = var.root_iops
  }

  subnet_id              = var.subnet_id
  vpc_security_group_ids = compact(concat(aws_security_group.this.*.id, var.additional_security_group_ids))

  iam_instance_profile = join("", aws_iam_instance_profile.this.*.id)
  key_name             = var.public_key_path == "" ? var.key_name : aws_key_pair.this.*.key_name[0]

  tags = merge({ Name = local.name_suffix }, var.tags)
}

