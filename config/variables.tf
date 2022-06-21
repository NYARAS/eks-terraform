variable "cluster_name" {
  type        = string
  description = "EKS cluster name."
}
variable "spot_termination_handler_chart_name" {
  type        = string
  description = "EKS Spot termination handler Helm chart name."
}
variable "spot_termination_handler_chart_repo" {
  type        = string
  description = "EKS Spot termination handler Helm repository name."
}
variable "spot_termination_handler_chart_version" {
  type        = string
  description = "EKS Spot termination handler Helm chart version."
}
variable "spot_termination_handler_chart_namespace" {
  type        = string
  description = "Kubernetes namespace to deploy EKS Spot termination handler Helm chart."
}

# create some variables
variable "external_dns_iam_role" {
  type        = string
  description = "IAM Role Name associated with external-dns service."
}
variable "external_dns_chart_name" {
  type        = string
  description = "Chart Name associated with external-dns service."
}

variable "external_dns_chart_repo" {
  type        = string
  description = "Chart Repo associated with external-dns service."
}

variable "external_dns_chart_version" {
  type        = string
  description = "Chart Repo associated with external-dns service."
}

variable "external_dns_values" {
  type        = map(string)
  description = "Values map required by external-dns service."
}

variable "name_prefix" {
  type        = string
  description = "Prefix to be used on each infrastructure object Name created in AWS."
}
variable "admin_users" {
  type        = list(string)
  description = "List of Kubernetes admins."
}
variable "developer_users" {
  type        = list(string)
  description = "List of Kubernetes developers."
}

variable "dns_hosted_zone" {
  type        = string
  description = "DNS Zone name to be used from EKS Ingress."
}
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

# create some variables
variable "namespaces" {
  type        = list(string)
  description = "List of namespaces to be created in our EKS Cluster."
}
