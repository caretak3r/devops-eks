variable "region" {
  type        = string
  description = "AWS region terraform is deploying to."
  default     = "us-east-1"
}
variable "prefix" {
  type        = string
  description = "Prefix to use for naming specific assets"
  default = "DevopsDev"
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
  default     = []
  description = "Additional attributes (e.g. `1`)"
}

variable "tags" {
  type        = map(string)
  default     = {
    BusinessUnit = "DevOps"
    ManagedBy    = "Terraform"
    SquadName    = "DevOps"
    Environment  = "dev"
    CostCenter   = "DevOps"
  }
  description = "Additional tags (e.g. `{ BusinessUnit = \"XYZ\" }`"
}