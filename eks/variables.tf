variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "private_subnets" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "eks_managed_node_groups" {
  type        = map(any)
  description = "Map of EKS managed node group definitions to create"
}

variable "cluster_version" {
  type        = string
  description = "Version of the eks cluster."
  default     = "1.32"
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
