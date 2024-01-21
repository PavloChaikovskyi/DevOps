# download website from GitHub repo to website repository 
git clone https://github.com/PavloChaikovskyi/Portfolio_PC.git
mkdir portfolio-website
sudo mv Portfolio_PC/Portfolio-Web-Page/* portfolio-website
sudo rm -r -f Portfolio_PC

# move created Dockerfile to website directory
sudo mv Dockerfile portfolio-website

#build my website docker image
sudo docker build -t portfolio-image ~/portfolio-website/

#run my website docker container
sudo docker run -d -p 80:80 --name portfolio-container portfolio-image