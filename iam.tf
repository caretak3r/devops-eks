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
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.ServiceRole.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.ServiceRole.name
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
    sid: "AWSELBPolicy"

    effect = "Allow"

    actions = [
      "elasticloadbalancing:*",
      "ec2:CreateSecurityGroup",
      "ec2:Describe*"
    ]

    resources = ["*"]
  }
}

resource "aws_iam_policy" "AmazonCloudWatchMetricsPolicy" {
  name = "AmazonCloudWatchMetricsPolicy"
  role = aws_iam_role.ServiceRole.name
  policy = data.aws_iam_policy_document.AmazonCloudWatchMetricsInline.json
}

resource "aws_iam_policy" "AmazonEKSLoadBalancerPolicy" {
  name = "AmazonEKSLoadBalancerPolicy"
  role = aws_iam_role.ServiceRole.name
  policy = data.aws_iam_policy_document.AmazonEKSLoadBalancerInline.json
}