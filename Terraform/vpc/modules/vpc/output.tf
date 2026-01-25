output "vpc_id" {

  value       = aws_vpc.main.id
  description = "vpc id"

}


output "internet_gw_id" {


  value       = aws_internet_gateway.igw.id
  description = "internet gateway id"

}

output "subnet_id_public" {

  value = aws_subnet.public[*].id

}




output "subnet_id_private" {

  value = aws_subnet.private[*].id


}

