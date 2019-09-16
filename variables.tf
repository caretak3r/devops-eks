terraform {
  required_version = ">= 0.12.7"
}

provider "aws" {
  version = ">= 2.11"
  region  = var.aws_region
  access_key = ""
  secret_key = ""
  token = ""
}

provider "random" {
  version = "~> 2.1"
}

provider "local" {
  version = "~> 1.2"
}

provider "null" {
  version = "~> 2.1"
}

provider "template" {
  version = "~> 2.1"
}

variable "aws_region" {
  default = "us-east-1"
}

variable "map_accounts" {
  description = "Additional AWS account numbers to add to the aws-auth configmap."
  type        = list(string)

  default = [
    "777777777777",
    "888888888888",
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

variable "eks-cluster-name" {
  type = string
  default = "devops-eks"
}

variable "prefix" {
  type = string
  default = "DevOps"
}

variable "whitelist" {
  type = list(string)
  default = ["96.64.69.249/32","216.1.21.2/32","199.189.66.234/32","144.121.156.210/32","10.0.0.0/8"]
}