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
   Name = "Ansible VPC"
 }
}

###################################################################################################
### GATEWAYS
###################################################################################################
resource "aws_internet_gateway" "gw" {
 vpc_id = aws_vpc.main.id
 
 tags = {
   Name = "Ansible GW"
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
resource "aws_instance" "ansible" {
  ami                    = "ami-0faab6bdbac9486fb"
  instance_type          = "t2.micro"
  tags                   = { Name = "Ansible" } 
  key_name               = aws_key_pair.ansible_ssh_key.key_name
  vpc_security_group_ids = [aws_security_group.allow_ssh_and_http_https.id]
  subnet_id              = aws_subnet.public_subnets[0].id  # Specify the subnet for each instance

  provisioner "file" {
    source      = "~/.ssh/id_rsa"
    destination = "/home/ubuntu/id_rsa"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mv /home/ubuntu/id_rsa ~/.ssh/id_rsa", #move ssh_key for webserver to .ssh folder
      "sudo chmod 600 ~/.ssh/id_rsa",
      "while [ ! -f /var/lib/cloud/instance/boot-finished ]; do echo 'Waiting for cloud-init...'; sleep 10; done", #be sure installing finished 
      "sudo apt update -y",
      "sudo apt install -y ansible", 
      "sudo apt-get install awscli -y", #aws cli & configure
      "aws configure set aws_access_key_id ${var.aws_access_key}",
      "aws configure set aws_secret_access_key ${var.aws_secret_key}",
      "aws configure set default.region ${var.aws_region}",
      file("scripts/get_ec2_ip_by_aws_cli.sh"), #save webserver public ip to .txt file on /home/ubuntu/.txt
      "git clone https://github.com/PavloChaikovskyi/Ansible.git",
      file("scripts/update_hosts.sh"),
      "sleep 10",
      "echo 'lets go! to play ansible'",
      "export ANSIBLE_CONFIG=~/Ansible/ansible.cfg",
      "ansible-playbook ~/Ansible/playbook.yml"
    ]
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("~/.ssh/ansible_key")
    host        = self.public_ip
  }
}

resource "aws_instance" "web_server" {
  ami                    = "ami-0faab6bdbac9486fb"
  instance_type          = "t2.micro"
  tags                   = { Name = "Webserver" }  
  key_name               = aws_key_pair.ssh_key.key_name
  vpc_security_group_ids = [aws_security_group.allow_ssh_and_http_https.id]
  subnet_id              = aws_subnet.public_subnets[1].id  # Specify the subnet for each instance
}

###################################################################################################
### KEY-PAIRS
###################################################################################################
resource "aws_key_pair" "ssh_key" {
  key_name   = "ssh_key"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_key_pair" "ansible_ssh_key" {
  key_name   = "ansible_key"
  public_key = file("~/.ssh/ansible_key.pub")
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

###################################################################################################
### OUTPUTS
###################################################################################################
output "webserver_public_ip" {
  value = aws_instance.web_server.public_ip
}

output "ansible_public_ip" {
  value = aws_instance.ansible.public_ip
}