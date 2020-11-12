variable "cloudwatch_enable" {
  description = "Enable CW"
  type        = bool
  default     = false
}

variable "logs_bucket_enable" {
  description = "Create bucket to put logs"
  type        = bool
  default     = false
}

variable "logging_bucket_name" {
  description = "Name of bucket for logs - blank for logs-<account-id>"
  type        = string
  default     = ""
}

resource "aws_s3_bucket" "logs" {
  count  = var.logs_bucket_enable && var.create ? 1 : 0
  bucket = var.logging_bucket_name == "" ? "${local.name_suffix}-logs-${data.aws_caller_identity.this.account_id}" : var.logging_bucket_name
  acl    = "private"

  tags = merge({ Name = local.name_suffix }, var.tags)
}

data "aws_iam_policy_document" "cloudwatch_agent" {
  statement {
    effect = "Allow"

    actions = [
      "ec2:DescribeTags",
      "cloudwatch:PutMetricData",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "cloudwatch_agent" {
  count = var.cloudwatch_enable && var.create ? 1 : 0

  name = "${local.name_camel_case}CloudwatchPutPolicy"

  role   = join("", aws_iam_role.this.*.id)
  policy = data.aws_iam_policy_document.cloudwatch_agent.json
}