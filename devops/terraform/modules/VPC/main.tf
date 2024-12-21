resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "cicd_vpc"
  }
}

locals {
  public_subnet_map = zipmap(range(length(var.public_subnets_cidr)), var.public_subnets_cidr)
}

resource "aws_subnet" "public" {
  for_each                = local.public_subnet_map
  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value
  availability_zone       = var.availability_zones[each.key % length(var.availability_zones)]
  map_public_ip_on_launch = true
  tags = {
    Name = "public-${each.value}-${var.availability_zones[each.key % length(var.availability_zones)]}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "igw"
  }
}

resource "aws_route_table" "public_rt" {
    vpc_id = aws_vpc.main.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }
}

resource "aws_route_table_association" "public_rta" {
    for_each = aws_subnet.public
    subnet_id      = each.value.id
    route_table_id = aws_route_table.public_rt.id
}