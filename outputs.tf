output "cluster_name" {
  description = "EKS Cluster Name"
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = module.eks.cluster_endpoint
}

output "cluster_id" {
  description = "EKS Cluster id."
  value = module.eks.cluster_id
}

output "oidc_provider_arn" {
  description = "The ARN of the OIDC Provider."
  value       = module.eks.oidc_provider_arn
}
output "oidc_provider_arn_issuer" {
  description = "The ARN of the OIDC Provider."
  value       = module.eks.oidc_provider_arn
}

output "cluster_certificate_authority_data" {
  description = "EKS Cluster certificate authority data."
  value = module.eks.cluster_certificate_authority_data
}

output "eks_role" {
  description = "EBS role."
  value = module.eks.eks-role
}
