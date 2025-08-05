resource "helm_release" "nginx" {
  name       = "nginx"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "nginx"
  version    = "15.0.0"
  namespace  = "default"

  set {
    name  = "service.type"
    value = "ClusterIP"
  }
}
