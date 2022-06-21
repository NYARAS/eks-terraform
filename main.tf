# create EKS cluster
module "base" {
  source = "./base/"

  cluster_name            = var.cluster_name
  name_prefix             = var.name_prefix
  main_network_block      = var.main_network_block
  subnet_prefix_extension = var.subnet_prefix_extension
  zone_offset             = var.zone_offset
  eks_managed_node_groups = var.eks_managed_node_groups
  autoscaling_average_cpu = var.autoscaling_average_cpu
}

# provision EKS cluster
module "config" {
  source = "./config/"

  cluster_name                             = module.base.cluster_id
  spot_termination_handler_chart_name      = var.spot_termination_handler_chart_name
  spot_termination_handler_chart_repo      = var.spot_termination_handler_chart_repo
  spot_termination_handler_chart_version   = var.spot_termination_handler_chart_version
  spot_termination_handler_chart_namespace = var.spot_termination_handler_chart_namespace
  dns_hosted_zone                          = var.dns_hosted_zone
  load_balancer_name                     = var.load_balancer_name
  alb_controller_iam_role                 = var.alb_controller_iam_role
  alb_controller_chart_name               = var.alb_controller_chart_name
  alb_controller_chart_repo               = var.alb_controller_chart_repo
  alb_controller_chart_version            = var.alb_controller_chart_version
  external_dns_iam_role                    = var.external_dns_iam_role
  external_dns_chart_name                  = var.external_dns_chart_name
  external_dns_chart_repo                  = var.external_dns_chart_repo
  external_dns_chart_version               = var.external_dns_chart_version
  external_dns_values                      = var.external_dns_values
  namespaces                               = var.namespaces
  name_prefix                              = var.name_prefix
  admin_users                              = var.admin_users
  developer_users                          = var.developer_users
}
