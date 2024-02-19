### TASK5 Description

###### THEORY
1. JENKINS
  - Groovy - language  (Jenkinsfile piplines) ! 
2. GITHUB ACTIONS : шо це таке

###### PRACTICE
1. Jenkins : 
 - web hook beetwen git and jenkins  
 - install and configure server
 - plugins (git i etc.)  (try to avoide plugins)
 - credentials
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
- terraform : 2 x ec2 ( test, deploy )
- jenkins: deploy custom index.html to nginx /var/www/html instead defauld

##### USEFULL MATERIALS

JENKINS: 
Install the latest LTS version:  
  > brew install jenkins-lts
Start the Jenkins service:  
  > brew services start jenkins-lts
STOP the Jenkins service:  
  > brew services stop jenkins-lts
Restart the Jenkins service:  
  > brew services restart jenkins-lts
Update the Jenkins version:  
  > brew upgrade jenkins-lts

Jenkins working link:   
- http://localhost:8080/

JENKINS PLUGINS: 
- Publish over SSH : connect to instances by SSH and make actions

TERRAFORM: 
> sudo chown -R ubuntu:root /var/www/html  // allow jenkins ubuntu user make changes in /var/www/html folder

[NGINX Configuration](https://ubuntu.com/tutorials/install-and-configure-nginx#1-overview)