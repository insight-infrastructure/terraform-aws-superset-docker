variable "create_iam" {
  description = "Bool to create iam role"
  type        = bool
  default     = false
}

variable "additional_policy_arns" {
  description = "List of additional policy arns"
  type        = list(string)
  default     = []
}

resource "aws_iam_role" "this" {
  count              = var.create && var.create_iam ? 1 : 0
  name               = "${local.name_camel_case}Role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = var.tags
}

resource "aws_iam_instance_profile" "this" {
  count = var.create && var.create_iam ? 1 : 0
  name  = "${local.name_camel_case}InstanceProfile"
  role  = join("", aws_iam_role.this.*.name)
}

resource "aws_iam_role_policy_attachment" "additional_policy_arns" {
  count      = var.create && var.create_iam ? length(var.additional_policy_arns) : 0
  role       = join("", aws_iam_role.this.*.id)
  policy_arn = var.additional_policy_arns[count.index]
}
