resource "aws_security_group" "AmazonEKSClusterSecurityGroup" {
  name = "${var.prefix}AmazonEKSClusterSecurityGroup"
  vpc_id = data.aws_vpc.shared-vpc.id
  description = "Communication between all nodes in the cluster"
}

resource "aws_security_group_rule" "cluster_ingress" {
  from_port = 0
  protocol = "-1"
  security_group_id = aws_security_group.AmazonEKSClusterSecurityGroup.id
  to_port = 0
  type = "ingress"
  self = true
}

resource "aws_security_group_rule" "cluster_egress" {
  from_port = 0
  protocol = "-1"
  security_group_id = aws_security_group.AmazonEKSClusterSecurityGroup.id
  to_port = 0
  type = "egress"
  cidr_blocks = ["0.0.0.0/0"]
}


resource "aws_security_group" "AmazonEKSControlPlaneSecurityGroup" {
  name = "AmazonEKSControlPlaneSecurityGroup"
  vpc_id = data.aws_vpc.shared-vpc.id
  description = "Communication between the control plane and worker nodegroups"
}

resource "aws_security_group_rule" "controlplane_ingress_https" {
  from_port = 443
  protocol = "tcp"
  security_group_id = aws_security_group.AmazonEKSControlPlaneSecurityGroup.id
  to_port = 443
  type = "ingress"
  source_security_group_id = aws_security_group.AmazonEKSWorkerNodeSecurityGroup.id
  description = "Allow control plane to receive API requests from worker nodes in group"
}

resource "aws_security_group_rule" "controlplane_egress_tcp" {
  from_port = 1025
  protocol = "tcp"
  security_group_id = aws_security_group.AmazonEKSControlPlaneSecurityGroup.id
  to_port = 65535
  type = "egress"
  source_security_group_id = aws_security_group.AmazonEKSWorkerNodeSecurityGroup.id
  description = "Allow control plane to communicate with worker nodes in group (kubelet and workload TCP ports)"
}

resource "aws_security_group_rule" "controlplane_egress_https" {
  from_port = 443
  protocol = "tcp"
  security_group_id = aws_security_group.AmazonEKSControlPlaneSecurityGroup.id
  to_port = 443
  type = "egress"
  source_security_group_id = aws_security_group.AmazonEKSWorkerNodeSecurityGroup.id
  description = "Allow control plane to communicate with worker nodes in group (workloads using HTTPS port, commonly used with extension API servers)"
}


resource "aws_security_group" "AmazonEKSWorkerNodeSecurityGroup" {
  name = "${var.prefix}AmazonEKSWorkerNodeSecurityGroup"
  vpc_id = data.aws_vpc.shared-vpc.id
  description = "Communication between the control plane and worker nodes in group"

  tags = {
    "kubernetes.io/cluster/${var.prefix}" = "owned"
  }

  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "nodegroup_ingress_https" {
  from_port = 443
  protocol = "tcp"
  security_group_id = aws_security_group.AmazonEKSWorkerNodeSecurityGroup.id
  to_port = 443
  type = "ingress"
  source_security_group_id = aws_security_group.AmazonEKSControlPlaneSecurityGroup.id
  description = "Allow worker nodes in group to communicate with control plane (workloads using HTTPS port, commonly used with extension API servers)"
}

resource "aws_security_group_rule" "nodegroup_ingress_tcp" {
  from_port = 1025
  protocol = "tcp"
  security_group_id = aws_security_group.AmazonEKSWorkerNodeSecurityGroup.id
  to_port = 65535
  type = "ingress"
  source_security_group_id = aws_security_group.AmazonEKSControlPlaneSecurityGroup.id
  description = "Allow worker nodes in group to communicate with control plane (kubelet and workload TCP ports)"
}

resource "aws_security_group_rule" "nodegroup_ingress_ssh" {
  from_port = 22
  protocol = "tcp"
  security_group_id = aws_security_group.AmazonEKSWorkerNodeSecurityGroup.id
  to_port = 22
  type = "ingress"
  cidr_blocks = ["10.0.0.0/8"]
  description = "Allow SSH and Admin access from within the VPC the cluster is deployed in"
}

resource "aws_security_group_rule" "nodegroup_ingress_elb" {
  from_port = 0
  protocol = "-1"
  security_group_id = aws_security_group.AmazonEKSWorkerNodeSecurityGroup.id
  to_port = 0
  type = "ingress"
  source_security_group_id = aws_security_group.whitelist.id
  description = "Allow traffic from the load balancer"
}

#resource "aws_security_group_rule" "nodegroup_egress_tcp" {
#  from_port = 0
#  protocol = "-1"
#  security_group_id = aws_security_group.AmazonEKSWorkerNodeSecurityGroup.id
#  to_port = 0
#  type = "egress"
#  cidr_blocks = ["0.0.0.0/0"]
#}

resource "aws_security_group" "whitelist" {
  name = "${var.prefix}AmazonEKSELBSecurityGroup"
  vpc_id = data.aws_vpc.shared-vpc.id
  description = "Allow Cadent whitelist"

  tags = {
    "kubernetes.io/cluster/${var.prefix}" = "owned"
  }
}

resource "aws_security_group_rule" "whitelist_ingress_https" {
  from_port = 443
  protocol = "tcp"
  security_group_id = aws_security_group.whitelist.id
  to_port = 443
  type = "ingress"

  for_each = toset(var.whitelist)
  cidr_blocks = [each.key]
}

resource "aws_security_group_rule" "whitelist_egress_tcp" {
  from_port = 0
  protocol = "-1"
  security_group_id = aws_security_group.whitelist.id
  to_port = 0
  type = "egress"
  cidr_blocks = ["0.0.0.0/0"]
}