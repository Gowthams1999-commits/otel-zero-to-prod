locals {

  env = "prod"

  common_tags = {

    managed_by = "terraform"
    project    = "otel"

  }
}

# VPC
resource "aws_vpc" "main" {


  cidr_block = var.vpc_cidr

  tags = merge({


    Name = "main-${local.env}"

    },

    local.common_tags

  )

}

# Internet gateway

resource "aws_internet_gateway" "igw" {


  vpc_id = aws_vpc.main.id

  tags = merge({

    Name = "igw-${local.env}"

    },

    local.common_tags
  )
}


# Public Subnets


resource "aws_subnet" "public" {

  count             = length(var.public_subnet_cidr)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_cidr[count.index]
  availability_zone = var.avz[count.index]

  map_public_ip_on_launch = true

  tags = merge(
    {
      Name = "public-${local.env}-${count.index + 1}"
    },
    local.common_tags
  )
}

# Private subnet

resource "aws_subnet" "private" {

  count             = length(var.private_subnet_cidr)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidr[count.index]
  availability_zone = var.avz[count.index]

  tags = merge(
    {

      Name = "private-${local.env}-${count.index + 1}"
    },
    local.common_tags
  )


}

## Elastic ip

resource "aws_eip" "eip" {
  count  = length(var.public_subnet_cidr)
  domain = "vpc"

  tags = merge({

    Name = "eip-${local.env}-${count.index + 1}"

    },

    local.common_tags

  )

}

## NAT gateway

resource "aws_nat_gateway" "nat_gw" {
  count         = length(var.public_subnet_cidr)
  allocation_id = aws_eip.eip[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = merge(
    {

      Name = "nat-gw-${local.env}-${count.index + 1}"

    },

    local.common_tags


  )

}

## Public Route table

resource "aws_route_table" "public" {


  vpc_id = aws_vpc.main.id

  route {

    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id

  }


  tags = merge(
    {

      Name = "public-RT-${local.env}"

    },

    local.common_tags
  )
}

## Private Route Table

resource "aws_route_table" "private" {

  count  = length(var.avz)
  vpc_id = aws_vpc.main.id

  route {


    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw[count.index].id

  }


  tags = merge({

    Name = "private-RT-${local.env}-${count.index + 1}"

    },

    local.common_tags
  )
}


## Route Table association for public subnet

resource "aws_route_table_association" "a" {
  count          = length(var.public_subnet_cidr)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}


## Route Table association for private subnet

resource "aws_route_table_association" "b" {
  count          = length(var.private_subnet_cidr)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}
