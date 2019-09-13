output "endpoint" {
  value = aws_eks_cluster.devops.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.devops.certificate_authority[0].data
}

