# aws user credentials: should be hidden
provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.aws_region
}

###################################################################################################
### EC2 INSTANCES
###################################################################################################
resource "aws_instance" "my_Ubuntu" {
  ami                    = "ami-0faab6bdbac9486fb"
  instance_type          = "t2.micro"
  tags                   = { Name = "Ubuntu" }
  key_name               = aws_key_pair.ssh_key.key_name
  vpc_security_group_ids = [aws_security_group.allow_ssh_and_http_https.id]

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("~/.ssh/id_rsa")
    host        = self.public_ip
  }
}

###################################################################################################
### KEY-PAIRS
###################################################################################################
# init ssh_key
resource "aws_key_pair" "ssh_key" {
  key_name   = "ssh_key"
  public_key = file("~/.ssh/id_rsa.pub")
}

###################################################################################################
### SECURITY GROUPS
###################################################################################################
resource "aws_security_group" "allow_ssh_and_http_https" {
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
# Output public IP address for convenience
output "public_ip" {
  value = aws_instance.my_Ubuntu.public_ip
}