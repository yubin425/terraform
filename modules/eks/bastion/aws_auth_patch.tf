data "template_file" "aws_auth" {
  template = file("${path.module}/scripts/aws-auth.yaml.tpl")
  vars = {
    role_arn = module.bastion.bastion_role_arn
  }
}

resource "null_resource" "patch_aws_auth" {
  provisioner "local-exec" {
    command = <<EOT
      aws eks update-kubeconfig --region ${var.region} --name ${module.cluster.cluster_name}
      echo '${data.template_file.aws_auth.rendered}' | kubectl apply -f -
    EOT
  }
  depends_on = [module.cluster, module.bastion]
}
