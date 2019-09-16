resource "aws_cloudwatch_log_group" "devops" {
  name = "/aws/eks/${var.prefix}/cluster"
  retention_in_days = 7
}

resource "aws_eks_cluster" "devops" {
  name = var.prefix
  role_arn = aws_iam_role.ServiceRole.arn
  vpc_config {
    subnet_ids = data.aws_subnet_ids.private.ids
    security_group_ids = [aws_security_group.AmazonEKSClusterSecurityGroup.id]
    endpoint_private_access = true
    endpoint_public_access = false
  }

  enabled_cluster_log_types = ["all"]

  depends_on = [
    "aws_cloudwatch_log_group.devops",
    "aws_iam_role_policy_attachment.AmazonEKSClusterPolicy",
    "aws_iam_role_policy_attachment.AmazonEKSServicePolicy",
  ]
}