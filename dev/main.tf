module "label" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.16.0"
  namespace  = var.namespace
  name       = var.name
  stage      = var.stage
  delimiter  = var.delimiter
  attributes = compact(concat(var.attributes, list("cluster")))
  tags       = var.tags
}

locals {
  tags = merge(module.label.tags, map("kubernetes.io/cluster/${module.label.id}", "shared"))
}

module "eks" {
  source      = "git::https://github.com/terraform-aws-modules/terraform-aws-eks.git"
  create_eks  = true
  vpc_id      = data.aws_vpc.default.id
  subnets     = data.aws_subnet_ids.private.ids

  cluster_name = module.label.id
  # https://docs.aws.amazon.com/eks/latest/userguide/platform-versions.html
  cluster_version = "1.14"
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access = true
  manage_cluster_iam_resources = true
  manage_worker_autoscaling_policy = true
  manage_worker_iam_resources = true
  manage_aws_auth = true
  write_kubeconfig = true

  cluster_log_retention_in_days = 7
  cluster_enabled_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  config_output_path = ".kube/"

  tags = local.tags

  worker_groups = [
    {
      name = "${var.prefix}-worker-ng"
      instance_type = "m5.large"
      autoscaling_enabled = true
      protect_from_scale_in = false
      asg_desired_capacity = "1" # currently it is being ignored in terraform to reduce complexity
      asg_max_size = "1"
      asg_min_size = "1"
      ebs_optimized = false
      key_name = "greenfield"
      worker_create_security_group = true

      tags = [
        {
          key                 = "kubernetes.io/cluster/${module.label.id}"
          value               = "shared"
          propagate_at_launch = true
        }
      ]
    }
  ]
}

module "eks_fargate_profile" {
      source               = "git::https://github.com/cloudposse/terraform-aws-eks-fargate-profile.git?ref=tags/0.1.0"
      namespace            = var.namespace
      stage                = var.stage
      name                 = var.name
      attributes           = var.attributes
      tags                 = var.tags
      subnet_ids           = data.aws_subnet_ids.private.ids
      cluster_name         = module.label.id
      kubernetes_namespace = var.namespace
}

# todo: put specific vars into terragrunt.hcl file with repository source
# todo: enable this when CA-autoscaler is ready