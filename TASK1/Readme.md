### TASK1 : description

1. Create AWS Account + User
2. Using terraform : create Ubuntu instance on AWS Cloud EC2 with SSH connection
3. Using terraform : add bash scripts to update connection permissions 
  -  root cannot connect by password : edit /etc/ssh/sshd_config file on server PermitRootLogin prohibit-password
  -  Ensure that users cannot login with password (hint: PasswordAuthentication) 
  -  create custom Motd message with help of [this link ](https://linuxconfig.org/how-to-change-welcome-message-motd-on-ubuntu-18-04-server ) 
4. Create clear development history with Git


#### WHAT WAS DONE : 
- created aws account with separate User with access key for ssh connection
- created ec2 instance with Ubuntu
- added SSH connection with key_pair 
- created security groups for SSH connection and outgoing HTTP/HTTPS traffic
- with provisioner copied local Motd message file to instance and provide changes to make it active on instance
- with provisioner added scripts that updates connection access on the instance
- all changes sent to GitHub Repo with commit history


##### FIXED PROBLEMS

apt update fail because of cloud-init processes not finished : 
[fix problem with update apt](https://stackoverflow.com/questions/42279763/why-does-terraform-apt-get-fail-intermittently)

> until [[ -f /var/lib/cloud/instance/boot-finished ]]; do
>  sleep 1
> done

##### USEFULL MATERIALS
- [ Youtube: AWS Lessons RU ](https://www.youtube.com/watch?v=8jbx8O3wuLg&list=PLg5SS_4L6LYsxrZ_4xE_U95AtGsIB96k9)
- [ Youtube: Terraform Lessons RU ](https://www.youtube.com/watch?v=R0CaxXhrfFE&list=PLg5SS_4L6LYujWDTYb-Zbofdl44Jxb2l8)
- [ Markdown syntax ](https://www.markdownguide.org/basic-syntax/)

