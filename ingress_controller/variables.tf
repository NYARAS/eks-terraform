variable "load_balancer_name" {
  type        = string
  description = "Load-balancer service name."
}
variable "alb_controller_iam_role" {
  type        = string
  description = "IAM Role Name associated with load-balancer service."
}
variable "alb_controller_chart_name" {
  type        = string
  description = "AWS Load Balancer Controller Helm chart name."
}
variable "alb_controller_chart_repo" {
  type        = string
  description = "AWS Load Balancer Controller Helm repository name."
}
variable "alb_controller_chart_version" {
  type        = string
  description = "AWS Load Balancer Controller Helm chart version."
}

variable "namespace" {
  type    = string
  default = "ingress-nginx"
}
# variable "domain" {
#   type = string
# }

variable "oidc_provider_arn" {
  description = "OIDC Provider ARN used for IRSA "
  type        = string
}
variable "shared_resource_name" {
  description = "A short string value to identify the subdomain of your WAS installation as well as all resources that Terraform will create."
  default     = "was"
  type        = string
}
