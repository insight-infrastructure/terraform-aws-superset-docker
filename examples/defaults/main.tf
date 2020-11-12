variable "aws_region" {
  default = "us-east-1"
}

provider "aws" {
  region = var.aws_region
}

variable "private_key_path" {}
variable "public_key_path" {}

module "defaults" {
  source           = "../.."
  private_key_path = var.private_key_path
  public_key_path  = var.public_key_path
}
