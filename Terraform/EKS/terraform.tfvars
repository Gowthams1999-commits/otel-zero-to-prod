cluster_name = "otel_cluster"

cluster_version = "1.29"

subnet_ids = ["subnet-05f4d748c10c5c0cc", "subnet-02456e2edb032fe81"]

node_gp_config = {



  on_demand = {
    instance_type = ["t3.medium"]
    capacity_type = "ON_DEMAND"

    scaling_config = {
      desired_size = 2
      min_size     = 2
      max_size     = 4
    }
  }

}
