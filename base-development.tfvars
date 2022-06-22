cluster_name            = "devops-demo-eks-cluster"
iac_environment_tag     = "development"
name_prefix             = "devops-demo-development"
main_network_block      = "10.0.0.0/16"
subnet_prefix_extension = 4
zone_offset             = 8

autoscaling_average_cpu = 30
eks_managed_node_groups = {
  "devops-eks-spot" = {
    ami_type     = "AL2_x86_64"
    min_size     = 1
    max_size     = 4
    desired_size = 1
    instance_types = [
      "t3.medium",
    ]
    capacity_type = "SPOT"
    network_interfaces = [{
      delete_on_termination       = true
      associate_public_ip_address = true
    }]
  }
  "devops-eks-ondemand" = {
    ami_type     = "AL2_x86_64"
    min_size     = 1
    max_size     = 4
    desired_size = 1
    instance_types = [
      "t3.medium",
    ]
    capacity_type = "ON_DEMAND"
    network_interfaces = [{
      delete_on_termination       = true
      associate_public_ip_address = true
    }]
  }
}
