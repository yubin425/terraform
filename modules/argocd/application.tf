resource "null_resource" "argocd_app_nginx" {
  provisioner "local-exec" {
    command = <<EOT
      kubectl apply -f ${path.module}/templates/nginx-app.yaml
    EOT
  }

  depends_on = [helm_release.argocd]
}
