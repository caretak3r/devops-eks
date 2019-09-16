module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "5.1.0"
  cluster_name = var.prefix
  subnets = data.aws_subnet_ids.private.ids
  vpc_id = data.aws_vpc.shared-vpc.id

  worker_groups = [
    {
      name = "${var.prefix}-worker-ng"
      instance_type = "m5.large"
      iam_instance_profile_name = aws_iam_instance_profile.node.name

      autoscaling_enabled = true
      asg_desired_capacity = "2"
      asg_max_size = "3"
      asg_min_size = "1"

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
  cluster_enabled_log_types = ["all"]
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access = false
  cluster_iam_role_name = aws_iam_role.ServiceRole.name
  cluster_log_retention_in_days = 7
  cluster_security_group_id = aws_security_group.AmazonEKSClusterSecurityGroup.id
}
