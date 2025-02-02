cluster_name            = "devops-demo-eks-cluster"
iac_environment_tag     = "development"
name_prefix             = "devops-demo"
main_network_block      = "10.0.0.0/16"
subnet_prefix_extension = 4
zone_offset             = 8

autoscaling_average_cpu = 30

eks_managed_node_groups = {
  general-services = {
    name = "general-services"

    instance_types = ["t3.medium"]

    min_size     = 4
    max_size     = 6
    desired_size = 6
  }
}
