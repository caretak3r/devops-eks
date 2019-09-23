module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "6.0.0"
  cluster_name = var.prefix
  subnets = data.aws_subnet_ids.private.ids
  vpc_id = data.aws_vpc.shared-vpc.id

  tags = {
    Environment = "shared-services"
    GithubRepo = "CadentTech/devops-eks"
  }

  worker_groups = [
    {
      name = "${var.prefix}-worker-ng"
      instance_type = "m5.large"
      iam_instance_profile_name = aws_iam_instance_profile.node.name
      autoscaling_enabled = false #todo: enable this when CA-autoscaler is ready
      protect_from_scale_in = false #todo: enable this when CA-autoscaler is ready
      asg_desired_capacity = "1" # currently it is being ignored in terraform to reduce complexity
      asg_max_size = "1"
      asg_min_size = "1"

      ebs_optimized = false

      key_name = "greenfield"

      tags = [
        {
          key                 = "kubernetes.io/cluster/${var.prefix}"
          value               = "owned"
          propagate_at_launch = true
        }
      ]
    }
  ]

  worker_security_group_id = aws_security_group.AmazonEKSWorkerNodeSecurityGroup.id
  cluster_enabled_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access = true
  cluster_iam_role_name = aws_iam_role.ServiceRole.name
  cluster_log_retention_in_days = 7
  cluster_security_group_id = aws_security_group.AmazonEKSClusterSecurityGroup.id

  map_users = var.map_users
  manage_aws_auth = true
  write_kubeconfig = true
  config_output_path = "/root/.kube/"
}
