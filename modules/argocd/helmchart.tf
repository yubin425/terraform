#helm chart 생성


resource "helm_release" "argocd" {
  namespace        = var.argocd_chart.namespace
  create_namespace = true
  repository       = var.argocd_chart.repository

  name    = var.argocd_chart.name
  chart   = var.argocd_chart.chart
  version = var.argocd_chart.version

  values = [
    yamlencode({
      server = {
        extraArgs = [
          "--insecure"
        ]
      }

      configs = {
        params = {
          "server.enable.gzip" = true
        }

        secret = {
          githubSecret = ""
          ## Argo expects the password in the secret to be bcrypt hashed. You can create this hash with
          argocdServerAdminPassword = ""
        }

        repositories = {
          "private-repo" = {
            url      = var.git_be_url
            project  = "default"
            type     = "git"
            # ArgoCD Personal Accesss Token
            password = ""
          }
        }
      }
    })
  ]
}

resource "helm_release" "argo_rollouts" {
  namespace        = var.argo_rollouts_chart.namespace
  create_namespace = true
  repository       = var.argo_rollouts_chart.repository

  name    = var.argo_rollouts_chart.name
  chart   = var.argo_rollouts_chart.chart
  version = var.argo_rollouts_chart.version

  values = [
    yamlencode({
      dashboard = {
          enabled = true
      }
    })
  ]

  depends_on = [helm_release.argocd]
}