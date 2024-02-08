#!/bin/bash

# Get the public IP from ~/public_ip.txt
public_ip=$(cat ~/public_ip.txt)

# Update hosts.txt with the new IP
sed -i "s/webserver ansible_host=.*/webserver ansible_host=${public_ip}/" hosts.txt
