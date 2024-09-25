module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.15.3"

  cluster_name    = var.cluster_name
  cluster_version = "1.30"

  vpc_id                         = var.vpc_id
  subnet_ids                     = var.private_subnets
  control_plane_subnet_ids       = var.private_subnets
  cluster_endpoint_public_access = true

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

  eks_managed_node_group_defaults = {
    ami_type = "AL2_x86_64"
  }

  eks_managed_node_groups = {
    general-services = {
      name = "general-services"

      instance_types = ["t3.medium"]

      min_size     = 1
      max_size     = 3
      desired_size = 2
    }

    specific-services = {
      name = "specific-service"

      instance_types = ["t3.small"]

      min_size     = 1
      max_size     = 2
    desired_size = 1
    }
  }
}
