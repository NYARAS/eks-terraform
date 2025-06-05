# data "aws_route53_zone" "domain" {
#   name         = "calvineotieno.com."
#   private_zone = false
# }

# locals {
#   ingress_svc_name      = "ingress-nginx-controller"
#   ingress_svc_namespace = "ingress-nginx"
#   ingress_load_balancer_tags = {
#     "service.k8s.aws/resource" = "LoadBalancer"
#     "service.k8s.aws/stack"    = "${local.ingress_svc_namespace}/${local.ingress_svc_name}"
#   }
# }

# # data "aws_lb" "ingress_load_balancer" {
# #   tags = local.ingress_load_balancer_tags
# # }

# variable "aws_region" {
#   default = "us-east-1"
#   type    = string
# }

# data "aws_elb_hosted_zone_id" "main" {}

# data "aws_lb_hosted_zone_id" "route53_zone_id_nlb" {
#   region             = var.aws_region
#   load_balancer_type = "network"
# }


# data "kubernetes_service" "ingress_nginx_controller" {
#   metadata {
#     name      = "ingress-nginx-controller"
#     namespace = var.namespace
#   }

#   depends_on = [helm_release.nginx-ingress-controller]
# }

# resource "aws_route53_record" "naked" {
#   zone_id = data.aws_route53_zone.domain.id
#   name    = var.domain
#   type    = "A"

#   alias {
#     name                   = data.kubernetes_service.ingress_nginx_controller.status.0.load_balancer.0.ingress.0.hostname
#     zone_id                = data.aws_lb_hosted_zone_id.route53_zone_id_nlb.id
#     evaluate_target_health = false
#   }
# }

# resource "aws_route53_record" "wildcard" {
#   zone_id = data.aws_route53_zone.domain.id
#   name    = "*.${var.domain}"
#   type    = "A"

#   alias {
#     name                   = data.kubernetes_service.ingress_nginx_controller.status.0.load_balancer.0.ingress.0.hostname
#     zone_id                = data.aws_lb_hosted_zone_id.route53_zone_id_nlb.id
#     evaluate_target_health = false
#     # evaluate_target_health = true
#   }
# }

# data "aws_lb" "mylb" {
#   name = split("-", split(".", data.kubernetes_service.ingress_nginx_controller.status.0.load_balancer.0.ingress.0.hostname).0).1
# }
