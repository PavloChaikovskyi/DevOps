# script for Ensure that root is not permitted to login with password : PermitRootLogin parameter

sshd_config="/etc/ssh/sshd_config"
sudo sed -i 's/#PermitRootLogin /PermitRootLogin /g' $sshd_config

# Restart the SSH service to apply changes
sudo systemctl restart ssh
