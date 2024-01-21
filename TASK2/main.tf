# aws user credentials: should be hidden
provider "aws" {}

###################################################################################################
### EC2 INSTANCES
###################################################################################################
# aws instance setting
resource "aws_instance" "my_Ubuntu" {
  ami                    = "ami-0faab6bdbac9486fb"
  instance_type          = "t2.micro"
  tags                   = { Name = "Ubuntu" }
  key_name               = aws_key_pair.ssh_key.key_name
  vpc_security_group_ids = [aws_security_group.allow_ssh_and_http_https.id]
  # Provisioner to execute remote script after instance will be installed
  provisioner "file" {
    source      = "scripts/01-custom"
    destination = "/tmp/01-custom"
  }
  provisioner "remote-exec" {
    inline = ["sudo mv /tmp/01-custom /etc/update-motd.d/01-custom"]
  }
  provisioner "remote-exec" {
    inline = [
      "while [ ! -f /var/lib/cloud/instance/boot-finished ]; do echo 'Waiting for cloud-init...'; sleep 1; done", #very important: help to avoid conflict before apt udates 
      "sudo apt update -y",
      file("scripts/root_login.sh"),
      file("scripts/users_login.sh"),
      "sudo chmod -x /etc/update-motd.d/*",
      "sudo chmod -x /usr/share/landscape/landscape-sysinfo.wrapper",
      "sudo chmod +x /etc/update-motd.d/01-custom",
    ]
  }
  provisioner "remote-exec" {
    inline = [
      "sudo apt install -y inxi screenfetch ansiweather",
      "sudo systemctl restart ssh",
    ]
  }
  # install docker engine to instance
    provisioner "remote-exec" {
    inline = [
      file("scripts/docker_install.sh"),
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