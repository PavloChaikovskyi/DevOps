# aws user credentials: should be hidden
provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.aws_region
}

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
  # provisioner "file" {
  #   source      = "scripts/01-custom"
  #   destination = "/tmp/01-custom"
  # }
  #copy Dockerfile to instance
  provisioner "file" {
    source      = "scripts/Dockerfile"
    destination = "/home/ubuntu/Dockerfile"
  }
  provisioner "file" {
    source      = "scripts/backup_script.sh"
    destination = "/home/ubuntu/backup_script.sh"
  }
  provisioner "remote-exec" {
    inline = [
      # "sudo mv /tmp/01-custom /etc/update-motd.d/01-custom",
      "sudo chmod +x /home/ubuntu/backup_script.sh",
      # execute script every day at 23:40 
      "echo '45 23 * * * /home/ubuntu/backup_script.sh' | crontab"
      ]
  }
  provisioner "remote-exec" {
    inline = [
      "while [ ! -f /var/lib/cloud/instance/boot-finished ]; do echo 'Waiting for cloud-init...'; sleep 1; done", #very important: help to avoid conflict before apt udates 
      "sudo apt update -y",
      # file("scripts/root_login.sh"),
      # file("scripts/users_login.sh"),
      # "sudo chmod -x /etc/update-motd.d/*",
      # "sudo chmod -x /usr/share/landscape/landscape-sysinfo.wrapper",
      # "sudo chmod +x /etc/update-motd.d/01-custom",
    ]
  }
  provisioner "remote-exec" {
    inline = [
      # "sudo apt install -y inxi screenfetch ansiweather",
      "sudo systemctl restart ssh",
    ]
  }
  provisioner "remote-exec" {
    inline = [
      # install aws cli and add credentials
      "sudo apt-get install awscli -y",
      "aws configure set aws_access_key_id ${var.aws_access_key}",
      "aws configure set aws_secret_access_key ${var.aws_secret_key}",
      "aws configure set default.region ${var.aws_region}",
      # install docker and debploy portfolio-website
      file("scripts/docker_install.sh"),
      file("scripts/deploy_website.sh"),
      # create s3 bucket
      "aws s3api create-bucket --bucket backup-pavlo-test-website --region eu-central-1 --create-bucket-configuration LocationConstraint=eu-central-1",
      # run backup script
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