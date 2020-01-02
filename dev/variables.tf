variable "map_accounts" {
  description = "Additional AWS account numbers to add to the aws-auth configmap."
  type        = list(string)

  default = [
    "837059289308",
  ]
}

# preexisting user+role
variable "map_roles" {
  description = "Additional IAM roles to add to the aws-auth configmap."
  type = list(object({
    rolearn  = string
    username = string
    groups   = list(string)
  }))

  default = [
    {
      rolearn  = "arn:aws:iam::837059289308:role/devops"
      username = "devops"
      groups   = ["system:masters"]
    },
  ]
}

# preexisting user+role
# using groups in RBAC is not yet supported
variable "map_users" {
  description = "Additional IAM users to add to the aws-auth configmap."
  type = list(object({
    userarn  = string
    username = string
    groups   = list(string)
  }))

  default = [
    {
      userarn  = "arn:aws:iam::837059289308:user/devops"
      username = "devops"
      groups   = ["system:masters"]
    },
  ]
}

# todo: move this to the vpc module, have "live" repo use existing tags to pull in data
# use data to pull in existing vpc by tag
data "aws_vpc" "default" {
  tags = { Environment = "shared-services" }
}

# todo: move this to the vpc module, have "live" repo use existing tags to pull in data
data "aws_subnet_ids" "public" {
  vpc_id = data.aws_vpc.default.id
  tags = { Network = "Public" }
}

# todo: move this to the vpc module, have "live" repo use existing tags to pull in data
data "aws_subnet_ids" "private" {
  vpc_id = data.aws_vpc.default.id
  tags = { Network = "Private" }
  filter {
    name = "tag:Name"
    values = ["cadent-ss-private-a", "cadent-ss-private-f"]
  }
}

variable "tags" {
  type        = map(string)
  description = "Additional tags (e.g. `{ BusinessUnit = \"XYZ\" }`"

  default     = {
    BusinessUnit = "DevOps"
    ManagedBy    = "Terraform"
    SquadName    = "DevOps"
    Environment  = "dev"
    CostCenter   = "DevOps"
  }
}

variable "whitelist" {
  type = list(string)
  description = "List of IP CIDRs to use to a security group"
  default = ["96.64.69.249/32","216.1.21.2/32","199.189.66.234/32","144.121.156.210/32","10.0.0.0/8"]
}

variable "region" {
  type = string
  description = "AWS region terraform is deploying to."
  default = "us-east-1"
}

variable "prefix" {
  type = string
  default = "Devops"
}

variable "namespace" {
  type        = string
  description = "Namespace, which could be your organization name, e.g. 'eg' or 'cp'"
  default     = ""
}

variable "stage" {
  type        = string
  description = "Stage, e.g. 'prod', 'staging', 'dev', 'mgmt', 'global' or 'test'"
  default     = ""
}

variable "name" {
  type        = string
  description = "Solution name, e.g. 'app' or 'cluster'"
}

variable "delimiter" {
  type        = string
  default     = "-"
  description = "Delimiter to be used between `namespace`, `stage`, `name` and `attributes`"
}

variable "attributes" {
  type        = list(string)
  default     = ["devops", "eks", "fargate"]
  description = "This could become the name for the module to name things with. attributes -> module.label.id = eks-fargate"
}

