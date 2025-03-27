# EKS Node Role 생성
resource "aws_iam_role" "eks-node-role" {
  name               = upper("aws-iam-${var.stage}-${var.servicename}-eks-node-role")
  assume_role_policy = data.aws_iam_policy_document.eks-node-policy.json
}

data "aws_iam_policy_document" "eks-node-policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "node_CloudWatchAgentServerPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  role       = aws_iam_role.eks-node-role.name
}

resource "aws_iam_role_policy_attachment" "node_AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks-node-role.name
}

resource "aws_iam_role_policy_attachment" "node_AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks-node-role.name
}

resource "aws_iam_role_policy_attachment" "node_AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks-node-role.name
}

resource "aws_iam_policy" "eks-node-policy" {
  name        = upper("aws-iam-policy-${var.stage}-${var.servicename}-eks-node")
  description = "eks-node-policy"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "cognito-idp:AdminInitiateAuth",
                "cognito-idp:AdminCreateUser",
                "cognito-idp:AdminSetUserPassword",
                "cognito-idp:AdminDeleteUser",
                "cognito-idp:AdminUserGlobalSignOut",
                "cognito-idp:AdminGetUser",
                "cognito-idp:AdminUpdateUserAttributes",
                "cognito-idp:AdminDisableUser",
                "cognito-idp:AdminEnableUser",
                "ses:SendEmail",
                "sqs:*",
                "s3:*",
                "dynamodb:*",
                "sns:CreatePlatformApplication",
                "sns:CreatePlatformEndpoint",
                "sns:DeletePlatformApplication",
                "sns:GetEndpointAttributes",
                "sns:GetPlatformApplicationAttributes",
                "sns:ListEndpointsByPlatformApplication",
                "sns:ListPlatformApplications",
                "sns:SetEndpointAttributes",
                "sns:SetPlatformApplicationAttributes",
                "sns:DeleteEndpoint",
                "sns:CreateTopic", "sns:ListTopics", "sns:SetTopicAttributes", "sns:DeleteTopic",
                "sns:Publish",
                "sns:GetTopicAttributes",
                "sns:ListTagsForResource",
                "sns:GetSubscriptionAttributes",
                "sns:Subscribe",
                "sns:Publish"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {   "Sid" : "TMPSTGCognito",
            "Action": [
                "sts:AssumeRole"
            ],
            "Resource": "*",
            "Effect": "Allow"
        }
    ]
}
EOF
}


resource "aws_iam_role_policy_attachment" "eks-node-policy-attachment" {
  policy_arn = aws_iam_policy.eks-node-policy.arn
  role       = aws_iam_role.eks-node-role.name
  #depends_on = [aws_iam_role.eks-cluster-autoscaling-role]
}