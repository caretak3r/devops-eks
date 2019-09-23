resource "aws_iam_role" "ServiceRole" {
  name = "${var.prefix}-ServiceRole"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  policy_arn  = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role        = aws_iam_role.ServiceRole.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKSServicePolicy" {
  policy_arn  = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role        = aws_iam_role.ServiceRole.name
}

data "aws_iam_policy_document" "AmazonCloudWatchMetricsInline" {
  statement {
    sid = "AWSCWMPolicy"

    effect = "Allow"

    actions = [
      "cloudwatch:PutMetricData"
    ]

    resources = ["*"]
  }
}

data "aws_iam_policy_document" "AmazonEKSLoadBalancerInline" {
  statement {
    sid = "AWSELBPolicy"

    effect = "Allow"

    actions = [
      "elasticloadbalancing:*",
      "ec2:CreateSecurityGroup",
      "ec2:Describe*"
    ]

    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "AmazonCloudWatchMetricsPolicy" {
  name        = "AmazonCloudWatchMetricsPolicy"
  role        = aws_iam_role.ServiceRole.name
  policy      = data.aws_iam_policy_document.AmazonCloudWatchMetricsInline.json
}

resource "aws_iam_role_policy" "AmazonEKSLoadBalancerPolicy" {
  name        = "AmazonEKSLoadBalancerPolicy"
  role        = aws_iam_role.ServiceRole.name
  policy      = data.aws_iam_policy_document.AmazonEKSLoadBalancerInline.json
}

# SECTION END

resource "aws_iam_role" "NodeInstanceRole" {
  name = "${var.prefix}-NodeInstanceRole"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.NodeInstanceRole.name
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnlyPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.NodeInstanceRole.name
}

resource "aws_iam_role_policy_attachment" "CloudWatchAgentServerPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  role       = aws_iam_role.NodeInstanceRole.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.NodeInstanceRole.name
}

resource "aws_iam_instance_profile" "node" {
  name      = "AmazonEKSNodeInstanceProfile"
  role      = aws_iam_role.NodeInstanceRole.name
}
