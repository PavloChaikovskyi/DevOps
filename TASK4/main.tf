###################################################################################################
### USER CREDENTIALS
###################################################################################################
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
### ROUTE ASSOTIATIONS
###################################################################################################
resource "aws_route_table_association" "public_subnet_asso" {
 count = length(var.public_subnet_cidrs)
 subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)
 route_table_id = aws_route_table.second_rt.id
}


###################################################################################################
### PUBLIC SUBNETS
###################################################################################################
resource "aws_subnet" "public_subnets" {
 count      = length(var.public_subnet_cidrs)
 vpc_id     = aws_vpc.main.id
 cidr_block = element(var.public_subnet_cidrs, count.index)
 availability_zone = element(var.azs_public, count.index)
 map_public_ip_on_launch = true # Enable automatic assignment of public IP addresses
 tags = {
   Name = "Public-Subnet-${count.index + 1}"
 }
}
 
###################################################################################################
### EC2 INSTANCES
###################################################################################################
resource "aws_instance" "my_Ubuntu" {
  count = length(var.public_subnet_cidrs)
  ami                    = "ami-0faab6bdbac9486fb"
  instance_type          = "t2.micro"
  tags                   = { Name = "Ubuntu-${count.index + 1}" } 
  key_name               = aws_key_pair.ssh_key.key_name
  vpc_security_group_ids = [aws_security_group.allow_ssh_and_http_https.id]
  subnet_id              = aws_subnet.public_subnets[count.index].id  # Specify the subnet for each instance
}

###################################################################################################
### KEY-PAIRS
###################################################################################################
resource "aws_key_pair" "ssh_key" {
  key_name   = "ssh_key"
  public_key = file("~/.ssh/id_rsa.pub")
}

###################################################################################################
### SECURITY GROUPS
###################################################################################################
resource "aws_security_group" "allow_ssh_and_http_https" {
  vpc_id = aws_vpc.main.id
  name        = "allow_ssh_and_http_https"
  description = "Allow incoming SSH and outgoing HTTP/HTTPS traffic"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow SSH traffic from any source
  }
  # add 80 port for webhost connection 
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow HTTP traffic from any source
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # Allow all outbound traffic
    cidr_blocks = ["0.0.0.0/0"]
  }
}