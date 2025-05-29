module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20"

  cluster_name                   = var.cluster_name
  cluster_version                = "1.32"
  cluster_endpoint_public_access = true
  # IPV6
  cluster_ip_family          = var.cluster_ip_family
  create_cni_ipv6_iam_policy = var.cluster_ip_family == "ipv6" ? true : false
  vpc_id                  = module.vpc.vpc_id
  subnet_ids         = module.vpc.private_subnets

  # Fargate profiles use the cluster primary security group so these are not utilized
  create_cluster_security_group = false
  create_node_security_group    = false

  enable_cluster_creator_admin_permissions = true
  cluster_compute_config = {
    enabled    = true
    node_pools = ["general-purpose"]
  }
  cluster_upgrade_policy = {
    support_type = "STANDARD"
  }
  access_entries = {}

  # enable_irsa = true
  tags = merge(local.tags, {
    "karpenter.sh/discovery" = var.cluster_name
  })
}
