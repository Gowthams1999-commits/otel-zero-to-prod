variable "cluster_name" {

  description = "cluster name"
  type        = string

}


variable "cluster_version" {

  description = "cluster version"
  type        = string

}


variable "subnet_ids" {

  type = list(string)

}



variable "node_gp_config" {


  type = map(object({

    instance_type = list(string)
    capacity_type = string

    scaling_config = object({

      desired_size = number
      max_size     = number
      min_size     = number

    })


  }))


}
