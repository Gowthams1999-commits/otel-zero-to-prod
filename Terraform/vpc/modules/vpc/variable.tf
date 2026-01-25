variable "vpc_cidr" {

  type = string

}

variable "avz" {

  type = list(string)

}

variable "public_subnet_cidr" {


  type = list(string)

}


variable "private_subnet_cidr" {


  type = list(string)

}
