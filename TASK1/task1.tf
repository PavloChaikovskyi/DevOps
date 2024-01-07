# aws user credentials: should be hidden

provider "aws" {}

# aws instance setting

resource "aws_instance" "my_Ubuntu" {
  ami = "ami-0faab6bdbac9486fb"
  instance_type = "t2.micro"
  tags = {
    Name = "Ubuntu"
  }
  key_name = aws_key_pair.ssh_key.key_name
  # Associate the instance with the security group
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
}

resource "aws_key_pair" "ssh_key" {
  key_name   = "ssh_key"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow incoming SSH traffic"
  
  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow SSH traffic from any source
  }
}