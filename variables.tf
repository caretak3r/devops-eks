provider "aws" {
  access_key = ""
  secret_key = ""
  token = ""
}

variable "aws_region" {
  default = "us-east-1"
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