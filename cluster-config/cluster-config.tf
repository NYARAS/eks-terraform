locals {
  chart_versions = {
    argocd           = "7.8.5",
    cert_manager     = "1.17.1",
    external_secrets = "0.14.3",
    external_dns     = "1.15.2",
    ingress_nginx    = "4.12.0",
  }
}
module "eks_blueprints_addons" {
  # count             = 0
  source            = "aws-ia/eks-blueprints-addons/aws"
  version           = "~> 1.20"
  cluster_name      = var.cluster_name
  cluster_endpoint  = var.cluster_endpoint
  cluster_version   = var.cluster_version
  oidc_provider_arn = var.oidc_provider_arn

  enable_argocd = true
  argocd = {
    chart_version = local.chart_versions.argocd
    values = [
      templatefile("${path.module}/../values/argocd.yaml",
        {
          issuer_name         = var.issuer_name
          hostname            = data.aws_route53_zone.eks.name
          redis_ha_enable     = var.redis_ha_enabled
          autoscaling_enabled = var.autoscaling_enabled
          ingress_class_name  = var.ingress_class_name
        }
      )
    ]
  }
  enable_external_secrets = true
  external_secrets = {
    chart_version = local.chart_versions.external_secrets
  }
  enable_cert_manager = true
  cert_manager = {
    chart_version = local.chart_versions.cert_manager
  }
  cert_manager_route53_hosted_zone_arns = [data.aws_route53_zone.eks.arn]
  enable_external_dns                   = true
  external_dns = {
    chart_version = local.chart_versions.external_dns
  }
  enable_ingress_nginx = true
  ingress_nginx = {
    chart_version = local.chart_versions.ingress_nginx
    values = [
      <<-EOT
    controller:
      allowSnippetAnnotations: true
      extraArgs:
        enable-ssl-passthrough: ""
      service:
        loadBalancerClass: "eks.amazonaws.com/nlb"
        annotations:
          service.beta.kubernetes.io/aws-load-balancer-backend-protocol: tcp
          service.beta.kubernetes.io/aws-load-balancer-cross-zone-load-balancing-enabled: "true"
          service.beta.kubernetes.io/aws-load-balancer-scheme: internet-facing
          service.beta.kubernetes.io/aws-load-balancer-type: nlb
      config:
        use-proxy-protocol: "false"
        real-ip-header: "proxy_protocol"
        use-forwarded-headers: "true"
    EOT
    ]
  }
  external_dns_route53_zone_arns = [data.aws_route53_zone.eks.arn]
  # enable_kube_prometheus_stack   = true
  # kube_prometheus_stack = {
  #   chart_version = local.chart_versions.kube_prometheus_stack
  # }

  tags = local.tags
}


locals {
  issuer_self_signed = <<EOF
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: selfsigned-issuer
  namespace: ${var.kubernetes_namespace}
  labels:
    app.kubernetes.io/name: cert-manager
    app.kubernetes.io/part-of: public-ingress
    app.kubernetes.io/component: self-signed
    app.kubernetes.io/managed-by: terraform
spec:
  selfSigned: {}
EOF

  issuer_letsencrypt_staging = <<EOF
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-staging-issuer
  namespace: ${var.kubernetes_namespace}
  labels:
    app.kubernetes.io/name: cert-manager
    app.kubernetes.io/part-of: public-ingress
    app.kubernetes.io/component: letsencrypt
    app.kubernetes.io/managed-by: terraform
spec:
  acme:
    server: https://acme-staging-v02.api.letsencrypt.org/directory
    email: ${var.Hostmaster}
    privateKeySecretRef:
      name: letsencrypt-staging
    solvers:
    - http01:
        ingress:
          class: ${var.ingress_class}
EOF

  issuer_letsencrypt_prod = <<EOF
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-prod
  namespace: ${var.kubernetes_namespace}
  labels:
    app.kubernetes.io/name: cert-manager
    app.kubernetes.io/part-of: public-ingress
    app.kubernetes.io/component: letsencrypt
    app.kubernetes.io/managed-by: terraform
spec:
  acme:
    server: https://acme-v02.api.letsencrypt.org/directory
    email: ${var.Hostmaster}
    privateKeySecretRef:
      name: letsencrypt-prod
    solvers:
    - http01:
        ingress:
          class: ${var.ingress_class}
EOF
}

resource "kubectl_manifest" "cluster-issuer" {
  depends_on = [module.eks_blueprints_addons]
  yaml_body  = <<YAML
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-prod
spec:
  acme:
    server: https://acme-v02.api.letsencrypt.org/directory
    email: ${var.Hostmaster}
    privateKeySecretRef:
      name: letsencrypt-key
    solvers:
    - http01:
        ingress:
          class: nginx
YAML
}

resource "kubectl_manifest" "cluster-issuer-staging" {
  depends_on = [module.eks_blueprints_addons]
  yaml_body  = <<YAML
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-staging
spec:
  acme:
    server: https://acme-staging-v02.api.letsencrypt.org/directory
    email: ${var.Hostmaster}
    privateKeySecretRef:
      name: letsencrypt-staging-key
    solvers:
    - http01:
        ingress:
          class: nginx
YAML
}

variable "kubernetes_namespace" {
  description = "The name of the namespace to insert the chart into"
  type        = string
  default     = "cert-manager"
}

variable "ingress_class" {
  description = "Ingress class to use for cert manager"
  type        = string
  default     = "nginx"
}

variable "Hostmaster" {
  type    = string
  default = "calvine@calvineotieno.com"
}
