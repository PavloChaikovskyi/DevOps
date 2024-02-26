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
  + git configaration with jenkinks
  + jenkins nodes 

  2. GitHub actions : 
  - створити репо в якому зберігаються всі файли для імеджа 
  - зробити пайплайн який буде збирати зробити репо з докер файлом імеджом і по коміту перебудовувати і грузити на докерхаб

  3. Jenkins
  - server by terraform with Jenkins inside docker with hostname public ip : шоб я зміг зайти на дженкінс на сайт через браузер.
  - під час створення дженкінс сервера додати файл output.tf і виводити туди публічний айпі адрес дженкінса і днс 
  - створити пайплайн який буде використ ансібел докер імедж і буде деплоїти новий індекс.html на сервер який я створив в поп тасках 

#### WHAT WAS DONE
  - install jenkins on local machine  
=== 
  - terraform : 2 x ec2 ( test, deploy )
  - jenkins: deploy custom index.html to nginx /var/www/html to [test, deploy]  
=== 
  - terraform: 2 x nodes
  - ansible : install java on [node1, node2] and create jenkins folder /home/ubuntu/jenkins
  - jenkins : add credentials (ssh-key) and create 2 nodes
  - jenkins : run job on nodes
  - jenkins cli : connected from local terminal to local jenkins server
===
  - jenkins : connect to git hub and send changes to webserver 

#### PROBLEMS DURING TASK (What was hard to solve)
Jenkins : create nodes : Launch method : credentials : +add jenkins : dont work 
  - option add in node didnt work but in Jenkins | Manage Jenkins | Manage Credentials did =) 
Jenkins CLI : couldnt connect because java was older than jenkins use : fixed with upgrading java version
Jenkins Job : send only files to my webserver not folders :  fix * to **/* 
Jenkins : for GitHub Hook Jenkins server should have public_ip acces : so run Jenkins on ec2
jenkins with github webhook : fix issue with jenkins user TOKEN and updated link in github webhook

#### USEFULL MATERIALS

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
- GITHUB           : add triger to build on changes in gitrepository

TERRAFORM:  
> sudo chown -R ubuntu:root /var/www/html  // allow jenkins ubuntu user make changes in /var/www/html folder  

ANSIBLE : installed on local machine  
  > ansible -m ping all                            // ping all hosts   
  > ansible-playbook playbook.yml --syntax-check   // check syntax of the playbook  
  > ansible-playbook playbook.yml --check          // check errors without real running scripts  
  > ansible-playbook playbook.yml                  // run playbook  

INSTALL JAVA
> brew install openjdk@11
> export JAVA_HOME=/usr/local/opt/openjdk@11
> export PATH=$JAVA_HOME/bin:$PATH

JENKINS CLI : 
> java -jar jenkins-cli.jar -auth name:pass[or Token] -s http://localhost:8080/ who-am-i
// best practices is to replace name and passw with environment variables : 
> export JENKINS_USER_ID=
> export JENKINS_API_TOKEN=

###### USEFULL LINKS ==========================================================================================================

[How to install nginx](https://ubuntu.com/tutorials/install-and-configure-nginx#1-overview)
[How to install java on nodes using ansible](https://brodevops.hashnode.dev/installing-java-and-mysql-db-using-ansible-playbook)
[Jenkins & GitHub WebHook](https://www.theserverside.com/blog/Coffee-Talk-Java-News-Stories-and-Opinions/Fix-No-Valid-Crumb-Error-Jenkins-GitHub-WebHook-Included)