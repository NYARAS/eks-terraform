module "vpc" {
  source       = "./vpc"
  vpc_name     = var.name_prefix
  cluster_name = var.cluster_name
}

# EKS Module
module "eks" {
  source = "./eks"

  cluster_name            = var.cluster_name
  vpc_id                  = module.vpc.vpc_id
  eks_managed_node_groups = var.eks_managed_node_groups
  private_subnets         = module.vpc.private_subnets
}

module "cert_manager" {
  source     = "./cert_manager"
  Hostmaster = var.Hostmaster

  depends_on = [module.eks]

}

module "nginx_ingress_controller" {
  source                       = "./ingress_controller"
  load_balancer_name           = var.load_balancer_name
  alb_controller_iam_role      = var.alb_controller_iam_role
  alb_controller_chart_name    = var.alb_controller_chart_name
  alb_controller_chart_repo    = var.alb_controller_chart_repo
  alb_controller_chart_version = var.alb_controller_chart_version
  oidc_provider_arn            = module.eks.oidc_provider_arn
  domain                       = var.domain

  depends_on = [module.eks]
}

module "gp3_storage_class" {
  depends_on        = [module.eks]
  source            = "./storage_classes"
  oidc_provider_arn = module.eks.oidc_provider_arn
  # cluster_endpoint = module.eks.cluster_endpoint
}
