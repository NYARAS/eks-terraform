spot_termination_handler_chart_name      = "aws-node-termination-handler"
spot_termination_handler_chart_repo      = "https://aws.github.io/eks-charts"
spot_termination_handler_chart_version   = "0.18.1"
spot_termination_handler_chart_namespace = "kube-system"


external_dns_iam_role      = "external-dns"
external_dns_chart_name    = "external-dns"
external_dns_chart_repo    = "https://kubernetes-sigs.github.io/external-dns/"
external_dns_chart_version = "1.9.0"

external_dns_values = {
  "image.repository"   = "k8s.gcr.io/external-dns/external-dns",
  "image.tag"          = "v0.11.0",
  "logLevel"           = "info",
  "logFormat"          = "json",
  "triggerLoopOnEvent" = "true",
  "interval"           = "5m",
  "policy"             = "sync",
  "sources"            = "{ingress}"
}

admin_users     = ["calvine-otieno", "jannet-kioko"]
developer_users = ["elvis-kariuki", "peter-donald"]

dns_hosted_zone              = "calvineotieno.com"
load_balancer_name           = "aws-load-balancer-controller"
alb_controller_iam_role      = "load-balancer-controller"
alb_controller_chart_name    = "aws-load-balancer-controller"
alb_controller_chart_repo    = "https://aws.github.io/eks-charts"
alb_controller_chart_version = "1.4.1"

namespaces = ["dev"]
