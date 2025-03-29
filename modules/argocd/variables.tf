variable "argocd_chart" {
  type        = map(string)
  description = "ArgoCD chart"
  default = {
    name       = "argocd"
    namespace  = "argocd"
    repository = "https://argoproj.github.io/argo-helm"
    chart      = "argo-cd"
    version    = "5.46.6"
  }
}

variable "argo_rollouts_chart" {
  type        = map(string)
  description = "Argo Rollouts chart"
  default = {
    name       = "argo-rollouts"
    namespace  = "argo-rollouts"
    repository = "https://argoproj.github.io/argo-helm"
    chart      = "argo-rollouts"
    version    = "2.31.1"
  }
}

variable "acm_certificate_arn" {
  description = "ARN of the ACM certificate for HTTPS"
  type        = string
}

variable "argocd_domain" {
  description = "Domain name for Argo CD UI"
  type        = string
}

variable "git_be_url" {
  description = "Domain name for Argo CD UI"
  type        = string
}