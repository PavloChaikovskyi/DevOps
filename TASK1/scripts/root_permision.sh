# script for Ensure that root is not permitted to login with password : PermitRootLogin parameter
# open file - find rule - and if it commented then uncomment it - and save the file could be with human manipulation

# Path to the sshd_config file
#sshd_config="/etc/ssh/sshd_config"

# Comment out the existing PermitRootLogin line if present
#sudo sed -i 's/^PermitRootLogin /#PermitRootLogin /' $sshd_config

# Add a new line to explicitly set PermitRootLogin to prohibit-password
#echo "PermitRootLogin prohibit-password" >> $sshd_config

# Restart the SSH service to apply changes
#systemctl restart ssh

echo "hello world" > /home/ubuntu/file.txt


