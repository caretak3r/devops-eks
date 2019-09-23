variable "aws_region" {
  default = "us-east-1"
}

variable "map_accounts" {
  description = "Additional AWS account numbers to add to the aws-auth configmap."
  type        = list(string)

  default = [
    "837059289308",
  ]
}

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

# use data to pull in existing vpc by tag
data "aws_vpc" "shared-vpc" {
  tags = { Environment = "shared-services" }
}

data "aws_subnet_ids" "public" {
  vpc_id = data.aws_vpc.shared-vpc.id
  tags = { Network = "Public" }
}

data "aws_subnet_ids" "private" {
  vpc_id = data.aws_vpc.shared-vpc.id
  tags = { Network = "Private" }
  filter {
    name = "tag:Name"
    values = ["cadent-ss-private-a", "cadent-ss-private-f"]
  }
}

output "vpc" {
  value = data.aws_vpc.shared-vpc.id
}

output "public" {
  value = data.aws_subnet_ids.public.ids
}

output "private" {
  value = data.aws_subnet_ids.private.ids
}

variable "prefix" {
  type = string
  default = "DevOps"
}

variable "whitelist" {
  type = list(string)
  default = ["96.64.69.249/32","216.1.21.2/32","199.189.66.234/32","144.121.156.210/32","10.0.0.0/8"]
}

variable "cluster_security_group_id" {
  value = aws_security_group.AmazonEKSClusterSecurityGroup.id
}