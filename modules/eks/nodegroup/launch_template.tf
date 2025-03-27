data "cloudinit_config" "workers_userdata" {
  gzip          = false
  base64_encode = true
  boundary      = "//"

  part {
    content_type = "text/x-shellscript"
    content = templatefile("${path.module}/templates/userdata.sh.tpl", {
      cluster_name         = var.cluster_id
      cluster_endpoint     = var.cluster_endpoint
      cluster_auth_base64  = var.cluster_ca_data
    })
  }
}
resource "aws_launch_template" "workers_launch_template" {
  name_prefix             = "aws-node-${var.stage}-${var.servicename}"
  update_default_version  = true

  monitoring {
    enabled = true
  }

  network_interfaces {
    associate_public_ip_address = false
    delete_on_termination       = true
    security_groups             = [aws_security_group.sg_eks_node.id]  # 위에서 생성한 보안 그룹 사용
  }

  # # IAM Instance Profile 추가
  # iam_instance_profile {
  #   name = aws_iam_instance_profile.eks_node_instance_profile.name
  # }

  #user_data = data.cloudinit_config.workers_userdata.rendered

  tag_specifications {
    resource_type = "instance"
    tags = merge(
      var.tags,
      {
        Name = "aws-node-${var.stage}-${var.servicename}"
      }
    )
  }
  tag_specifications {
    resource_type = "volume"
    tags = merge(
      var.tags,
      {
        Name = "aws-node-vol-${var.stage}-${var.servicename}"
      }
    )
  }
  tag_specifications {
    resource_type = "network-interface"
    tags = merge(
      var.tags,
      {
        Name = "aws-node-eni-${var.stage}-${var.servicename}"
      }
    )
  }
  tags = var.tags

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    aws_security_group.sg_eks_node,
    aws_iam_role_policy_attachment.node_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.node_AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.node_AmazonEC2ContainerRegistryReadOnly
  ]
}
