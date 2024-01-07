# aws user credentials: should be hidden

provider "aws" {}

# aws instance setting

resource "aws_instance" "my_Ubuntu" {
  ami = "ami-0faab6bdbac9486fb"
  instance_type = "t2.micro"
  tags = {
    Name = "Ubuntu"
  }

  # add ssh_key to instance 
  key_name = aws_key_pair.ssh_key.key_name

  # Associate the instance with the security group for SSH connection
  vpc_security_group_ids = [aws_security_group.allow_ssh_and_http_https.id]
}

# init ssh_key
resource "aws_key_pair" "ssh_key" {
  key_name   = "ssh_key"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_security_group" "allow_ssh_and_http_https" {
  name        = "allow_ssh_and_http_https"
  description = "Allow incoming SSH and outgoing HTTP/HTTPS traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow SSH traffic from any source
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # Allow all outbound traffic
    cidr_blocks = ["0.0.0.0/0"]
  }
}
