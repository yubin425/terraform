data "template_file" "aws_auth" {
  template = file("${path.module}/aws-auth.yaml.tpl")
  vars = {
    role_arn = module.eks_bastion.bastion_role_arn
  }
}

resource "null_resource" "patch_aws_auth" {
  provisioner "local-exec" {
    command = <<EOT
      aws eks update-kubeconfig --region ${var.region} --name ${module.eks_cluster.cluster_name}
      echo '${data.template_file.aws_auth.rendered}' | kubectl apply -f -
    EOT
  }
  depends_on = [module.eks_cluster, module.eks_bastion]
}
