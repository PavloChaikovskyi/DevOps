echo "#!/bin/sh" | sudo tee /etc/update-motd.d/99-custom-motd
echo 'echo "Custom message! Hello dear user"' | sudo tee -a /etc/update-motd.d/99-custom-motd
sudo chmod +x /etc/update-motd.d/99-custom-motd