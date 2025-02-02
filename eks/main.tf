module "eks" {
  source                         = "terraform-aws-modules/eks/aws"
  version                        = "20.8.4"
  cluster_name                   = var.cluster_name
  cluster_version                = "1.31"
  cluster_endpoint_public_access = true
  create_iam_role                = false
  iam_role_arn                   = aws_iam_role.eks-role.arn

  cluster_enabled_log_types   = []
  create_cloudwatch_log_group = false

  enable_irsa                              = true
  enable_cluster_creator_admin_permissions = true
  authentication_mode                      = "API_AND_CONFIG_MAP"
  vpc_id                                   = var.vpc_id
  subnet_ids                               = var.private_subnets
  control_plane_subnet_ids                 = var.private_subnets

  tags = {
    cluster = "demo"
  }

  cluster_addons = {
    coredns = {
      resolve_conflicts = "OVERWRITE"
    }
    eks-pod-identity-agent = {}
    kube-proxy             = {}
    vpc-cni = {
      resolve_conflicts = "OVERWRITE"
    }
  }

  # eks_managed_node_group_defaults = {
  #   ami_type       = "AL2_x86_64"
  #   instance_types = ["t3.medium"]
  # }

  eks_managed_node_groups = var.eks_managed_node_groups

  depends_on = [
    aws_iam_role_policy_attachment.eks-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.eks-AmazonEKSVPCResourceController,
  ]

  cluster_security_group_additional_rules = {
    ingress_node_vault_port = {
      description                = "Vault Port"
      protocol                   = "tcp"
      from_port                  = 8200
      to_port                    = 8200
      type                       = "ingress"
      source_node_security_group = true
    }
  }

}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "eks-role" {
  name               = "eks-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "eks-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks-role.name
}

resource "aws_iam_role_policy_attachment" "eks-AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.eks-role.name
}
