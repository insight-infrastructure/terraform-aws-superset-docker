data "aws_caller_identity" "this" {}
data "aws_region" "this" {}

locals {
  name_camel_case = replace("${title(var.name)}${title(var.suffix)}", "/[_\\s]", "-")
  name_suffix     = var.suffix != "" ? "${var.name}-${var.suffix}" : var.name == "" ? "superset" : var.name
}