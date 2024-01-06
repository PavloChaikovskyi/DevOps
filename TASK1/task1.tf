# aws user credentials: should be hidden

provider "aws" {}

# aws instance setting

resource "aws_instance" "my_Ubuntu" {
  ami = "ami-0faab6bdbac9486fb"
  instance_type = "t2.micro"
  tags = {
    Name = "ubuntu"
  }
}