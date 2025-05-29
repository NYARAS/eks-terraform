variable "cluster_name" {
  default     = "dev-eit"
  description = "Name of the Cluster"
  type        = string
}
variable "cluster_ip_family" {
  default     = "ipv4"
  description = "IP Family"
  type        = string
}
variable "env" {
  default     = "dev"
  description = "Name of the environment"
  type        = string
}
variable "vpc_block" {
  default     = "172.16.0.0/16"
  description = "VPC CIDR Block"
  type        = string
}
variable "saml_role_arn" {
  default = "arn:aws:iam::652750967253:role/global-DeptAdmin-1WL9N53EKDOP8"
  type    = string
}
variable "dns_zone" {
  description = "DNS Zone"
  type        = string
  default     = "calvineotieno.com"
}
data "aws_route53_zone" "eks" {
  name = var.dns_zone
}
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
data "aws_eks_cluster_auth" "default" {
  name = var.cluster_name
}
locals {
  tags = {
    Environment   = var.env
    Project       = "kube"
    Managed       = "true"
    ManagedBy     = "Terraform"
    TerraformRepo = "https://code.umd.edu/eit/development/kube"
  }
}
