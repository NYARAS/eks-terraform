# deploy 'external-dns' service
# https://github.com/kubernetes-sigs/external-dns
resource "helm_release" "external_dns" {
  name       = var.external_dns_chart_name
  chart      = var.external_dns_chart_name
  repository = var.external_dns_chart_repo
  version    = var.external_dns_chart_version
  namespace  = "kube-system"

  dynamic "set" {
    for_each = var.external_dns_values

    content {
      name  = set.key
      value = set.value
      type  = "string"
    }
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.external_dns_iam_role}"
  }

  # will make ExternalDNS see only the hosted zones matching provided domain, omit to process all available hosted zones
  set {
    name  = "domainFilters"
    value = "{${var.dns_hosted_zone}}"
  }

  set {
    name  = "txtOwnerId"
    value = data.aws_route53_zone.hosted_zone.zone_id
  }
}
