terraform {
  required_version = ">= 0.12.7"
}

provider "aws" {
  version = ">= 2.28.1"
  region  = var.region
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
