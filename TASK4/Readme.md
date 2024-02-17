### TASK4 Description

###### THEORY
1. Theory Virtualization : watch matherials 06
2. [Ansible Theory!!!](https://www.youtube.com/playlist?list=PLg5SS_4L6LYufspdPupdynbMQTBnZd31N) + 07 Materials 
3. Vagrant, Chief, Puppet - (get acquainted)

###### PRACTICE
1. Using Ansible create WebServer from task 2 
  - create ec2 by terraform for ansible
  - create ec2 by terraform for webserver
  - locally create ansible script for deploying website to ec2 webserver
  - push it to separate github repository with ansible configs
  - pull ansible configs to ec2 ansible and run scripts to create WebServer from task 2

2. Create Ansible Docker Image with credentials and add it to DockerHub for have a possibility to use Ansible by Jenkins
  - check if container running properly locally
  - send it to dockerhub

#### WHAT WAS DONE

Part1: 
  - Private VPC : 3 AZ / 3 Public Subnets / 3 Instances in each / 
  ![ec2.png](images/ec2.png) 
  - Launch to ec2 instance with ansible 
  ![pin-pong.png](images/pin-pong.png) 

Part2: 
- run ec2 instance "webserver" :
- run ec2 instance "ansible" : 
  - install aws cli
  - copy private ssh key for web server 
  - get public api from webserver by aws cli 
  - install ansible
  - download ansible scripts from github by terraform

- ansible scripts : 
  - connect to webserver with ssh
  - get website from git 
  - get dockerfile from git
  - install docker
  - create docker image
  - run docker container



- hosts.txt має генеруватись на льоту в залежності від даних які нам потрібні для того щоб залогінитись на веб сервер
- впершу чергу пропишу команди локально щоб запустити веб сервер а потім те саме проверну вже з інстанса ансібла

який файл відповідає за скрипти на законекченному ансіблом інстансі?
прописати потрібні скрипти

##### USEFULL MATERIALS

aws cli : get list of ec2 instances public ip  
> aws ec2 describe-instances --query 'Reservations[].Instances[].[InstanceId, PublicIpAddress]' --output table

get answer pong from connected servers
> ansible -i hosts.txt all -m ping  

> ansible all -m ping

see the tree of ansible hierarchy 
> ansible-inventory --list  

generate local key_pair
> ssh-keygen -t rsa -b 2048 -f ~/.ssh/my_key_pair

get public ip with aws instance by tag 
> aws ec2 describe-instances \
>  --filters "Name=tag:Name,Values=Web Server" \
>  --query "Reservations[].Instances[].[PublicIpAddress]" \
>  --output text

[Download Docker with Ansible playbook](https://www.digitalocean.com/community/tutorials/how-to-use-ansible-to-install-and-set-up-docker-on-ubuntu-20-04)

передача змінних середовища під час запуску докер контейнера; 
docker run -e ANSIBLE_HOST=3.74.151.67 -e ANSIBLE_SSH_KEY=~/.ssh/id_rsa.pub -e ANSIBLE_USER=ubuntu my-ansible-image
