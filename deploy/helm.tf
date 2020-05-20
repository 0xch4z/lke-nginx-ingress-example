resource "helm_release" "nginx-ingress-release" {
  name       = "nginx-ingress"
  repository = "https://kubernetes-charts.storage.googleapis.com/"
  chart      = "nginx-ingress"

  set {
    name  = "controller.publishService.enabled"
    value = "true"
  }

  depends_on = [
    null_resource.kubeconfig_fetch
  ]
}

resource "helm_release" "cert-manager-release" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"

  set {
    name  = "installCRDs"
    value = "true"
  }

  depends_on = [
    null_resource.kubeconfig_fetch
  ]
}
