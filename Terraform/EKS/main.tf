module "eks" {

  source          = "./modules/eks"
  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  subnet_ids      = var.subnet_ids
  node_gp_config  = var.node_gp_config


}
