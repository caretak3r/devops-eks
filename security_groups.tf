resource "aws_security_group" "AmazonEKSClusterSecurityGroup" {
  name = "${var.prefix}AmazonEKSClusterSecurityGroup"
  vpc_id = data.aws_vpc.shared-vpc.id
  description = "Communication between all nodes in the cluster"

  ingress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    self = true
    description = "Allow nodes to communicate with each other (all ports)"
  }

  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "AmazonEKSControlPlaneSecurityGroup" {
  name = "AmazonEKSControlPlaneSecurityGroup"
  vpc_id = data.aws_vpc.shared-vpc.id
  description = "Communication between the control plane and worker nodegroups"

  ingress {
    from_port = 443
    protocol = "tcp"
    to_port = 443
    security_groups = [aws_security_group.AmazonEKSWorkerNodeSecurityGroup.id]
    description = "Allow control plane to receive API requests from worker nodes in group"
  }

  egress {
    from_port = 1025
    protocol = "tcp"
    to_port = 65535
    cidr_blocks = [aws_security_group.AmazonEKSWorkerNodeSecurityGroup.id]
    description = "Allow control plane to communicate with worker nodes in group (kubelet and workload TCP ports)"
  }

  egress {
    from_port = 443
    protocol = "tcp"
    to_port = 443
    security_groups = [aws_security_group.AmazonEKSWorkerNodeSecurityGroup.id]
    description = "Allow control plane to communicate with worker nodes in group (workloads using HTTPS port, commonly used with extension API servers)"
  }
}

resource "aws_security_group" "AmazonEKSWorkerNodeSecurityGroup" {
  name = "${var.prefix}AmazonEKSWorkerNodeSecurityGroup"
  vpc_id = data.aws_vpc.shared-vpc.id
  description = "Communication between the control plane and worker nodes in group"

  ingress {
    from_port = 443
    protocol = "tcp"
    to_port = 443
    security_groups = [aws_security_group.AmazonEKSControlPlaneSecurityGroup.id]
    description = "Allow worker nodes in group to communicate with control plane (workloads using HTTPS port, commonly used with extension API servers)"
  }

  ingress {
    from_port = 1025
    protocol = "tcp"
    to_port = 65535
    security_groups = [aws_security_group.AmazonEKSControlPlaneSecurityGroup.id]
    description = "Allow worker nodes in group to communicate with control plane (kubelet and workload TCP ports)"
  }

  ingress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = [data.aws_vpc.shared-vpc.cidr_block]
    description = "Allow SSH and Admin access from within the VPC the cluster is deployed in"
  }

  ingress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    security_groups = [aws_security_group.whitelist.id]
    description = "Allow traffic from the whitelisted security group"
  }

  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "whitelist" {
  name = "${var.prefix}AmazonEKSELBSecurityGroup"
  vpc_id = data.aws_vpc.shared-vpc.id
  description = "Allow Cadent whitelist"

  dynamic ingress {
    for_each = toset(var.whitelist)
    content {
      from_port = 443
      protocol = "tcp"
      to_port = 443
      cidr_blocks = [each.key]
    }
  }
}