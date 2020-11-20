# terraform-aws-superset-docker

[![open-issues](https://img.shields.io/github/issues-raw/insight-infrastructure/terraform-aws-superset-docker?style=for-the-badge)](https://github.com/insight-infrastructure/terraform-aws-superset-docker/issues)
[![open-pr](https://img.shields.io/github/issues-pr-raw/insight-infrastructure/terraform-aws-superset-docker?style=for-the-badge)](https://github.com/insight-infrastructure/terraform-aws-superset-docker/pulls)

## Features

This module sets up Apache Superset with ansible which configures a node to run docker-compose.

## Terraform Versions

For Terraform v0.12.0+

## Usage

```hcl
variable "private_key_path" {}
variable "public_key_path" {}

module "this" {
  source = "github.com/insight-infrastructure/terraform-aws-superset-docker"
  private_key_path = var.private_key_path
  public_key_path  = var.public_key_path
}
```
## Examples

- [defaults](https://github.com/insight-infrastructure/terraform-aws-superset-docker/tree/master/examples/defaults)

## Known  Issues
No issue is creating limit on this module.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| additional\_policy\_arns | List of additional policy arns | `list(string)` | `[]` | no |
| additional\_security\_group\_ids | List of security groups | `list(string)` | `[]` | no |
| ami | AMI to use as base image - blank for ubuntu | `string` | `""` | no |
| bastion\_ip | Optional IP for bastion - blank for no bastion | `string` | `""` | no |
| bastion\_user | Optional bastion user - blank for no bastion | `string` | `""` | no |
| cloudwatch\_enable | Enable CW | `bool` | `false` | no |
| create | Boolean to create resources or not | `bool` | `true` | no |
| create\_dns | Bool to create ssl cert and nginx proxy | `bool` | `true` | no |
| create\_iam | Bool to create iam role | `bool` | `false` | no |
| create\_sg | Bool for create security group | `bool` | `true` | no |
| domain\_name | The domain - example.com. Blank for no ssl / nginx | `string` | `""` | no |
| enable\_superset\_ssl | Bool to enable SSL | `bool` | `true` | no |
| hostname | The hostname - ie hostname.example.com - blank for example.com | `string` | `""` | no |
| instance\_type | Instance type | `string` | `"t3.small"` | no |
| key\_name | The key pair to import - leave blank to generate new keypair from pub/priv ssh key path | `string` | `""` | no |
| logging\_bucket\_name | Name of bucket for logs - blank for logs-<account-id> | `string` | `""` | no |
| logs\_bucket\_enable | Create bucket to put logs | `bool` | `false` | no |
| monitoring | Boolean for cloudwatch | `bool` | `false` | no |
| name | The name for the label | `string` | `"superset"` | no |
| playbook\_vars | Additional playbook vars | `map(string)` | `{}` | no |
| private\_key\_path | The path to the private ssh key | `string` | n/a | yes |
| private\_port\_cidrs | List of CIDR blocks for private ports | `list(string)` | <pre>[<br>  "172.31.0.0/16"<br>]</pre> | no |
| private\_ports | List of publicly open ports | `list(number)` | `[]` | no |
| public\_key\_path | The path to the public ssh key | `string` | n/a | yes |
| public\_ports | List of publicly open ports | `list(number)` | <pre>[<br>  22,<br>  80,<br>  443,<br>  8088<br>]</pre> | no |
| root\_iops | n/a | `string` | n/a | yes |
| root\_volume\_size | Root volume size | `number` | `8` | no |
| root\_volume\_type | n/a | `string` | `"gp2"` | no |
| subnet\_id | The id of the subnet | `string` | `""` | no |
| suffix | Suffix to attach to name | `string` | `""` | no |
| superset\_env\_file\_path | Path to .env file for deployment | `string` | `""` | no |
| tags | Map of tags | `map(string)` | `{}` | no |
| vpc\_id | Custom vpc id - leave blank for deault | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| instance\_id | n/a |
| instance\_type | n/a |
| key\_name | n/a |
| public\_ip | n/a |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Testing
This module has been packaged with terratest tests

To run them:

1. Install Go
2. Run `make test-init` from the root of this repo
3. Run `make test` again from root

## Authors

Module managed by [insight-infrastructure](https://github.com/insight-infrastructure)

## Credits

- [Anton Babenko](https://github.com/antonbabenko)

## License

Apache 2 Licensed. See LICENSE for full details.