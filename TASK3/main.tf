# aws user credentials: should be hidden
provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.aws_region
}

###################################################################################################
### VPC
###################################################################################################
resource "aws_vpc" "main" {
 cidr_block = "10.0.0.0/16" 
 tags = {
   Name = "Pavlo VPC"
 }
}

###################################################################################################
### GATEWAYS
###################################################################################################
resource "aws_internet_gateway" "gw" {
 vpc_id = aws_vpc.main.id
 
 tags = {
   Name = "Pavlo GW"
 }
}

###################################################################################################
### ROUTE TABLES
###################################################################################################
resource "aws_route_table" "second_rt" {
 vpc_id = aws_vpc.main.id
 
 route {
   cidr_block = "0.0.0.0/0"
   gateway_id = aws_internet_gateway.gw.id
 }
 
 tags = {
   Name = "2nd Route Table"
 }
}

###################################################################################################
### PUBLIC SUBNETS
###################################################################################################
resource "aws_subnet" "public_subnets" {
 count      = length(var.public_subnet_cidrs)
 vpc_id     = aws_vpc.main.id
 cidr_block = element(var.public_subnet_cidrs, count.index)
 availability_zone = element(var.azs_public, count.index)
 tags = {
   Name = "Public-Subnet-${count.index + 1}"
 }
}
 
###################################################################################################
### PRIVATE SUBNETS
###################################################################################################
resource "aws_subnet" "private_subnets" {
 count      = length(var.private_subnet_cidrs)
 vpc_id     = aws_vpc.main.id
 cidr_block = element(var.private_subnet_cidrs, count.index)
 availability_zone = element(var.azs_private, count.index)
 tags = {
   Name = "Private-Subnet-${count.index + 1}"
 }
}
