variable "env" {
  default     = "dev"
  description = "Name of the environment"
  type        = string
}

variable "ingress_class_name" {
  type        = string
  default     = "nginx"
  description = "Enter ingress class name which is created in EKS cluster"
}

variable "redis_ha_enabled" {
  type    = bool
  default = false
}
variable "autoscaling_enabled" {
  type    = bool
  default = false
}


variable "issuer_name" {
  type        = string
  description = "Enter ingress class name which is created in EKS cluster"
  default     = "letsencrypt-prod"
}

variable "cluster_name" {
  default     = "dev-eit"
  description = "Name of the Cluster"
  type        = string
}

variable "cluster_endpoint" {
  type        = string
  description = "Endpoint for EKS control plane"
}

variable "oidc_provider_arn" {
  description = "OIDC Provider ARN used for IRSA "
  type        = string
}

variable "cluster_version" {
  type        = string
  description = "Version of the eks cluster."
  default     = "1.32"
}

variable "dns_zone" {
  description = "DNS Zone"
  type        = string
  default     = "calvineotieno.com"
}
