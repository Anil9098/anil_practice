#!/bin/bash

aws --version

public_ip=$(aws ec2 describe-instances --query "Reservations[].Instances[].PublicIpAddress" --output text)

#public_ip=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=server" --query "Reservations[].Instances[].[PublicIpAddress]" --output text)

for ip in $public_ip; do
    echo "Processing IP: $ip"
    ssh -i "/home/ncs/Downloads/jenkinsnodekey.pem" ubuntu@$ip <<EOF
    rm -rf anil_practice
    git clone https://github.com/Anil9098/anil_practice.git
    cd anil_practice/bash
    ./example_deployment.sh
EOF
done




