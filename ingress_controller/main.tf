module "lb_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name                              = "eks-lb"
  attach_load_balancer_controller_policy = true

  oidc_providers = {
    main = {
      provider_arn               = var.oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-load-balancer-controller"]
    }
  }
}

################################################################################
# Aws Load balancer Controller Service Account
################################################################################

resource "kubernetes_service_account" "lb_controller" {
  metadata {
    name      = var.load_balancer_name
    namespace = "kube-system"

    labels = {
      "app.kubernetes.io/component" = "controller"
      "app.kubernetes.io/name"      = var.load_balancer_name
    }
    annotations = {
      "eks.amazonaws.com/role-arn"               = module.lb_role.iam_role_arn
      "eks.amazonaws.com/sts-regional-endpoints" = "true"
    }
  }
}


# deploy Ingress Controller (AWS ALB Ingresss Controller)
# https://github.com/kubernetes-sigs/aws-load-balancer-controller/tree/main/helm/aws-load-balancer-controller
resource "helm_release" "ingress_gateway" {
  name       = var.alb_controller_chart_name
  chart      = var.alb_controller_chart_name
  repository = var.alb_controller_chart_repo
  version    = var.alb_controller_chart_version
  namespace  = "kube-system"

  set {
    name  = "clusterName"
    value = var.shared_resource_name
  }

  set {
    name  = "serviceAccount.name"
    value = kubernetes_service_account.lb_controller.metadata.0.name
  }

  set {
    name  = "serviceAccount.create"
    value = "false"
  }
}

resource "helm_release" "ingress-nginx" {
  name             = "ingress-nginx"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  namespace        = "ingress-nginx"
  create_namespace = true
  version          = "4.10.0" // move this to variables
  values = [
    templatefile(
      "${path.module}/chart_values.tmpl", {}
    )
  ]
}
