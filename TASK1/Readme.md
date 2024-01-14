TASK1

- create Ubuntu server on aws with terraform +++
- connect with SSH +++
- 1.1 root cannot connect by password : edit /etc/ssh/sshd_config file on server PermitRootLogin prohibit-password
  - there is 2 option : 
    - manually on the server file +++
    - by terraform script during execution - currently in progress


[fix problem with update apt](https://stackoverflow.com/questions/42279763/why-does-terraform-apt-get-fail-intermittently)

> until [[ -f /var/lib/cloud/instance/boot-finished ]]; do
>  sleep 1
> done


