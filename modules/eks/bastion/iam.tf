data "aws_iam_policy_document" "bastion_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "bastion_role" {
  name               = "bastion-role-${var.stage}-${var.servicename}"
  assume_role_policy = data.aws_iam_policy_document.bastion_assume_role.json
  tags               = var.tags
}

resource "aws_iam_role_policy_attachment" "bastion_eks_access" {
  role       = aws_iam_role.bastion_role.name
  policy_arn = aws_iam_policy.baston_describe_cluster_policy.arn
}

resource "aws_iam_instance_profile" "bastion_profile" {
  name = "bastion-profile-${var.stage}-${var.servicename}"
  role = aws_iam_role.bastion_role.name
}

resource "aws_iam_role_policy_attachment" "this" {
  for_each = toset([
    "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy",
    "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess",
    "arn:aws:iam::aws:policy/AmazonEKSServicePolicy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  ])
  role       = aws_iam_role.bastion_role.name
  policy_arn = each.value
}

resource "aws_iam_policy" "baston_describe_cluster_policy" {
  name        = "eks-describe-cluster-policy"
  description = "Policy to allow eks:DescribeCluster"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "eks:DescribeCluster",
          "sts:GetCallerIdentity"
        ]
        Resource = "*"
      }
    ]
  })
}
