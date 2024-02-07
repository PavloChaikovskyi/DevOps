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

#### WHAT WAS DONE

Part1: 
  - Private VPC : 3 AZ / 3 Public Subnets / 3 Instances in each / 
  ![ec2.png](images/ec2.png) 
  - Launch to ec2 instance with ansible 
  ![pin-pong.png](images/pin-pong.png) 

Part2: 
- run two ec2 instances : ( 1st for Ansible : with configuration, 2nd for Web Server) in my VPC on aws cloud
- 


##### USEFULL MATERIALS

aws cli : get list of ec2 instances public ip  
> aws ec2 describe-instances --query 'Reservations[].Instances[].[InstanceId, PublicIpAddress]' --output table

> ansible -i hosts.txt all -m ping  
> ansible all -m ping  
> ansible-inventory --list  

generate local key_pair
> ssh-keygen -t rsa -b 2048 -f ~/.ssh/my_key_pair
