#########
# Ansible
#########
variable "playbook_vars" {
  description = "Additional playbook vars"
  type        = map(string)
  default     = {}
}

variable "bastion_user" {
  description = "Optional bastion user - blank for no bastion"
  type        = string
  default     = ""
}

variable "bastion_ip" {
  description = "Optional IP for bastion - blank for no bastion"
  type        = string
  default     = ""
}

variable "enable_superset_ssl" {
  description = "Bool to enable SSL"
  type        = bool
  default     = true
}

variable "superset_env_file_path" {
  description = "Path to .env file for deployment"
  type        = string
  default     = ""
}

variable "certbot_admin_email" {
  description = "Email to register SSL cert with"
  type        = string
  default     = ""
}

locals {
  certbot_admin_email = var.certbot_admin_email == "" ? "admin@${var.domain_name}" : var.certbot_admin_email
}

variable "superset_username" {
  description = "The superset username"
  type        = string
  default     = "superset"
}

variable "superset_firstname" {
  description = "The superset firstname"
  type        = string
  default     = "ICON"
}

variable "superset_lastname" {
  description = "The superset lastname"
  type        = string
  default     = "Todamoon"
}

variable "superset_email" {
  description = "The superset email"
  type        = string
  default     = "recovery@email.com"
}

variable "superset_password" {
  description = "The superset password"
  type        = string
  default     = "changemenow"
}

variable "superset_database_import_yaml_path" {
  description = "The path to database import file"
  type        = string
  default     = ""
}

module "ansible" {
  source           = "github.com/insight-infrastructure/terraform-aws-ansible-playbook.git?ref=v0.14.0"
  create           = var.create
  ip               = join("", aws_eip_association.this.*.public_ip)
  user             = "ubuntu"
  private_key_path = pathexpand(var.private_key_path)

  bastion_ip   = var.bastion_ip
  bastion_user = var.bastion_user

  playbook_file_path = "${path.module}/ansible/main.yml"
  playbook_vars = merge({
    superset_username  = var.superset_username
    superset_firstname = var.superset_firstname
    superset_lastname  = var.superset_lastname
    superset_email     = var.superset_email
    superset_password  = var.superset_password

    superset_database_import_yaml_path = var.superset_database_import_yaml_path

    cloudwatch_enable = var.cloudwatch_enable
    //    ssl_enable          = var.domain_name != "" ? false : var.enable_superset_ssl
    ssl_enable          = false # TODO ^^ -
    env_file_path       = var.superset_env_file_path
    certbot_admin_email = local.certbot_admin_email
    fqdn                = local.fqdn
  }, var.playbook_vars)

  requirements_file_path = "${path.module}/ansible/requirements.yml"
}
