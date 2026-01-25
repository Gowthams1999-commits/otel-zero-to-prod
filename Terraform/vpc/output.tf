output "vpc_id" {

  value = module.vpc.vpc_id


}


output "internet_gw_id" {

  value = module.vpc.internet_gw_id

}

output "subnet_id_public" {

  value = module.vpc.subnet_id_public

}


output "subnet_id_private" {


  value = module.vpc.subnet_id_private

}
