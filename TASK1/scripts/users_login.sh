# script for Ensure that users are not permitted to login with password : PasswordAuthentication parameter

sshd_config="/etc/ssh/sshd_config"
sudo sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/g' $sshd_config

# Restart the SSH service to apply changes
sudo systemctl restart ssh