### TASK5 Description

  ###### THEORY TASK
  1. JENKINS
    - Groovy - language  (Jenkinsfile piplines) ! 
  2. GITHUB ACTIONS : шо це таке

  ###### PRACTICE TASK
  1. Jenkins : 
  - web hook beetwen git and jenkins  ( залогінитись в гіт хаб )
  + install and configure server 
  + plugins (git i etc.)  (try to avoide plugins)
  + credentials
  - piplines  
  - git configaration with jenkinks
  - jenkins nodes 

  2. GitHub actions : 
  - створити репо в якому зберігаються всі файли для імеджа 
  - зробити пайплайн який буде збирати зробити репо з докер файлом імеджом і по коміту перебудовувати і грузити на докерхаб
  - Dockerhub 

  3. Jenkins
  - server by terraform with Jenkins inside docker with hostname public ip : шоб я зміг зайти на дженкінс на сайт через браузер.
  - під час створення дженкінс сервера додати файл output.tf і виводити туди публічний айпі адрес дженкінса і днс 
  - створити пайплайн який буде використ ансібел докер імедж і буде деплоїти новий індекс.html на сервер який я створив в поп тасках 

#### WHAT WAS DONE
- install jenkins on local machine  
A.
  - terraform : 2 x ec2 ( test, deploy )
  - jenkins: deploy custom index.html to nginx /var/www/html to [test, deploy]  
B.  
  - terraform: 2 x nodes
  - ansible : install java on [node1, node2]

#### PROBLEMS DURING TASK (What was hard to solve)

##### USEFULL MATERIALS

JENKINS: installed on local machine : http://localhost:8080/
  
  > brew install jenkins-lts                // Install the latest LTS version  
  > brew services start jenkins-lts         // Start the Jenkins service  
  > brew services stop jenkins-lts          // STOP the Jenkins service  
  > brew services restart jenkins-lts       // Restart the Jenkins service   
  > brew upgrade jenkins-lts                // Update the Jenkins version  


JENKINS PLUGINS: 
- Publish over SSH : connect to instances by SSH and make actions
- GIT plugin       : 
- SSH server       : 
- SSH Agent        : save ssh key and username in credentials  
- SSH Build Agents : possibility to add agents by ssh

TERRAFORM:  
> sudo chown -R ubuntu:root /var/www/html  // allow jenkins ubuntu user make changes in /var/www/html folder  

ANSIBLE : installed on local machine  
  > ansible -m ping all                            // ping all hosts   
  > ansible-playbook playbook.yml --syntax-check   // check syntax of the playbook  
  > ansible-playbook playbook.yml --check          // check errors without real running scripts  
  > ansible-playbook playbook.yml                  // run playbook  


###### USEFULL LINKS ==========================================================================================================

[How to install nginx](https://ubuntu.com/tutorials/install-and-configure-nginx#1-overview)
[How to install java on nodes using ansible](https://brodevops.hashnode.dev/installing-java-and-mysql-db-using-ansible-playbook)
