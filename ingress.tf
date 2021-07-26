resource "kubernetes_ingress" "dev_ingress_rule" {
  metadata {
    name      = "dev-ingress-rule"
    namespace = "dev"
  }

  spec {
    rule {
      host = "example-dev.neo"

      http {
        path {
          path = "/"

          backend {
            service_name = "example-service"
            service_port = "80"
          }
        }
      }
    }
  }
}

resource "kubernetes_ingress" "qa_ingress_rule" {
  metadata {
    name      = "qa-ingress-rule"
    namespace = "qa"
  }

  spec {
    rule {
      host = "example-qa.neo"

      http {
        path {
          path = "/"

          backend {
            service_name = "example-service"
            service_port = "80"
          }
        }
      }
    }
  }
}

resource "kubernetes_ingress" "prod_ingress_rule" {
  metadata {
    name      = "prod-ingress-rule"
    namespace = "prod"
  }

  spec {
    rule {
      host = "example-prod.neo"

      http {
        path {
          path = "/"

          backend {
            service_name = "example-service"
            service_port = "80"
          }
        }
      }
    }
  }
}
