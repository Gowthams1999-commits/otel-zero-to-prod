module "vpc" {


  source              = "./modules/vpc"
  vpc_cidr            = var.vpc_cidr
  avz                 = var.avz
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr

}
