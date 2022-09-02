
# decleration of vpc
resource "aws_vpc" "test_vpc" {
  cidr_block = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name ="${terraform.workspace}_vpc"
    env = "${terraform.workspace}"
  }
}

data "aws_availability_zones" "available"{
  state = "available"
}

# decleration of public subnet
# resource "aws_subnet" "pub-snet" {
#     count = length(var.pubcidr)
#     vpc_id     = aws_vpc.test_vpc.id 
#     cidr_block = var.pubcidr[count.index]
# availability_zone = data.aws_availability_zones.available.names[count.index]
# map_public_ip_on_launch = true

# tags = {
#  Name = "${terraform.workspace}_pub_snet${count.index+1}_${data.aws_availability_zones.available.names[count.index]}"
#  env = "${terraform.workspace}"
# }
# }

resource "aws_subnet" "pub-snet" {
    for_each = var.pub_sn_details
    vpc_id     = aws_vpc.test_vpc.id 
    cidr_block = each.value["cidr_block"]
    availability_zone = each.value["availability_zone"]
    map_public_ip_on_launch = true

# tags = {
#  Name = "${terraform.workspace}_pub_snet${count.index+1}_${data.aws_availability_zones.available.names[count.index]}"
#  env = "${terraform.workspace}"
# }
}

# decleration of private subnet
# resource "aws_subnet" "pri-snet" {
#  count = length(var.pricidr)
#  vpc_id = aws_vpc.test_vpc.id
#  cidr_block = var.pricidr[count.index]
# availability_zone = data.aws_availability_zones.available.names[count.index]
 
#  tags= {
#  Name = "${terraform.workspace}_pri_snet${count.index+1}_${data.aws_availability_zones.available.names[count.index]}"
#  env = "${terraform.workspace}"
#  }
# }

resource "aws_subnet" "pri-snet" {
 for_each = var.pvt_sn_details
 vpc_id = aws_vpc.test_vpc.id
 cidr_block = each.value["cidr_block"]
  availability_zone = each.value["availability_zone"]
 
#  tags= {
#  Name = "${terraform.workspace}_pri_snet${count.index+1}_${data.aws_availability_zones.available.names[count.index]}"
#  env = "${terraform.workspace}"
#  }
}

# creating igw for pub snet
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.test_vpc.id

  tags = {
    Name = "${terraform.workspace}_vpc_pub_igw"
    env = "${terraform.workspace}"  
  }
}

# creating a igw route table
  resource "aws_route_table" "pub_rt" {
  vpc_id = aws_vpc.test_vpc.id

    route {
   cidr_block = "0.0.0.0/0"
   gateway_id = aws_internet_gateway.igw.id
   }

   tags = {
   Name = "${terraform.workspace}_vpc_pub_rt"
   env = "${terraform.workspace}"
   }
 }

 # associating a igw in a subnet
#  resource "aws_route_table_association" "vpc_asoc" {
#  count = length (var.pubcidr)
#  subnet_id   = aws_subnet.pub-snet[count.index].id
#  route_table_id = aws_route_table.pub_rt.id
#  }

resource "aws_route_table_association" "pbsnet_assoc" {
 for_each = aws_subnet.pub-snet
 subnet_id   = each.value.id
 route_table_id = aws_route_table.pub_rt.id
}

#  resource "aws_eip" "eip-for-nat" { }

#  resource "aws_nat_gateway" "nat1-for-pvtec2" {
#   # for_each = var.pub_sn_details
#   count = var.nat_reqd ? 1 : 0
#   allocation_id = aws_eip.eip-for-nat.id
#   connectivity_type = "public"
#   # subnet_id     = aws_subnet.pub-snet[each.key].id
#   subnet_id = lookup(aws_subnet.pub-snet,var.pub-snet-name, null).id

#   tags = {
#     Name = "gw NAT1"
#   }

#   # To ensure proper ordering, it is recommended to add an explicit dependency
#   # on the Internet Gateway for the VPC.
#   # depends_on = [aws_internet_gateway.example]
# }
