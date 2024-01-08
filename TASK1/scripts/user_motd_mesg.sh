echo "Hello dear user" | sudo tee /etc/update-motd.d/99-custom-motd
sudo chmod +x /etc/update-motd.d/99-custom-motd
sudo systemctl restart ssh