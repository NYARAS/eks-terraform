module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.24"

  cluster_name                   = var.cluster_name
  cluster_version                = "1.30"
  cluster_endpoint_public_access = true
  # IPV6
  cluster_ip_family          = var.cluster_ip_family
  create_cni_ipv6_iam_policy = var.cluster_ip_family == "ipv6" ? true : false
  vpc_id                     = module.vpc.vpc_id
  subnet_ids                 = module.vpc.private_subnets

  # Fargate profiles use the cluster primary security group so these are not utilized
  create_cluster_security_group = false
  create_node_security_group    = false

  enable_cluster_creator_admin_permissions = true

  access_entries = {
  }

  cluster_addons = {
    aws-ebs-csi-driver = {
      most_recent       = true
      resolve_conflicts = "OVERWRITE"
    }
    coredns = {
      most_recent = true
    }
    vpc-cni = {
      most_recent    = true
      before_compute = true
      configuration_values = jsonencode({
        env = {
          ENABLE_PREFIX_DELEGATION = "true"
          WARM_PREFIX_TARGET       = "1"
        }
      })
    }
    kube-proxy = { most_recent = true }
    eks-pod-identity-agent = {
      most_recent = true
    }
  }
  enable_irsa = true
  eks_managed_node_groups = {
    eks_mng = {
      max_size       = 3
      min_size       = 3
      desired_size   = 3
      instance_types = ["t4g.medium"]
      ami_type       = "BOTTLEROCKET_ARM_64"
      # key_name         = var.key_name
      subnets = module.vpc.private_subnets
      update_config = {
        max_unavailable = 1
      }
    }
  }

  tags = merge(local.tags, {
    "karpenter.sh/discovery" = var.cluster_name
  })
}
