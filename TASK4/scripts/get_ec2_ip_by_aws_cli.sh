#!/bin/bash

tag_name="Webserver"

# Check if an instance with the specified tag exists
while true; do
  instance_id=$(aws ec2 describe-instances \
    --filters "Name=tag:Name,Values=$tag_name" \
    --query "Reservations[].Instances[?State.Name=='running'].InstanceId" \
    --output text)

  if [ -n "$instance_id" ]; then
    echo "instance_id : $instance_id"
    break
  else
    echo "Waiting for an instance with tag '$tag_name' to exist..."
    sleep 5
  fi
done
# Wait for the instance to be in 'running' state
while true; do

  echo "Webserver id before IF: $instance_id"

  state=$(aws ec2 describe-instances \
    --instance-ids $instance_id \
    --query "Reservations[].Instances[].State.Name" \
    --output text)


  echo "state BEFORE IF : $state"  

  if [ "$state" = "running" ]; then
    public_ip=$(aws ec2 describe-instances \
      --instance-ids $instance_id \
      --query "Reservations[].Instances[].PublicIpAddress" \
      --output text)
    
    echo "HURAAAHHHH DOOONNEEEE"
    echo "Webserver Public IP: $public_ip"
    echo "$public_ip" > ~/public_ip.txt
    

    break
  else

    echo "IT DOESNT WORK =("
    echo "Webserver id: $instance_id"
    echo "state : $state"
    echo "public_ip: $public_ip"
    echo "Waiting for the instance to be in 'running' state..."
    sleep 10
  fi
done
