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
