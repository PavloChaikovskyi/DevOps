###################################################################################################
### USER CREDENTIALS
###################################################################################################
provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.aws_region
}

 
###################################################################################################
### EC2 INSTANCES
###################################################################################################
resource "aws_instance" "node1" {
  ami                    = "ami-0faab6bdbac9486fb"
  instance_type          = "t2.micro"
  tags                   = { Name = "TEST" } 
  key_name               = aws_key_pair.ssh_key1.key_name
  vpc_security_group_ids = [aws_security_group.ssh_web.id]

  provisioner "remote-exec" {
    inline = [
      "while [ ! -f /var/lib/cloud/instance/boot-finished ]; do echo 'WAITING for cloud-init...'; sleep 1; done", #be sure ec2 installing finished 
      "sudo apt update -y",
    ]
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("~/.ssh/id_rsa")
    host        = self.public_ip
  }
}

resource "aws_instance" "node2" {
  ami                    = "ami-0faab6bdbac9486fb"
  instance_type          = "t2.micro"
  tags                   = { Name = "DEPLOY" }  
  key_name               = aws_key_pair.ssh_key1.key_name
  vpc_security_group_ids = [aws_security_group.ssh_web.id]

  provisioner "remote-exec" {
    inline = [
      "while [ ! -f /var/lib/cloud/instance/boot-finished ]; do echo 'WAITING for cloud-init...'; sleep 1; done", #be sure ec2 installing finished 
      "sudo apt update -y",

    ]
  }

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
resource "aws_key_pair" "ssh_key1" {
  key_name   = "ssh_key1"
  public_key = file("~/.ssh/id_rsa.pub")
}

###################################################################################################
### SECURITY GROUPS
###################################################################################################
resource "aws_security_group" "ssh_web" {
  name        = "ssh_web"
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
output "node1_public_ip" {
  value = aws_instance.node1.public_ip
}

output "node2_public_ip" {
  value = aws_instance.node2.public_ip
}