#!/bin/bash


# ssh on ec2 and run commands
sudo ssh -i /root/.ssh/id_rsa ubuntu@13.233.100.250 <<EOF
# Commands to run inside EC2
echo "Running script on EC2 instance"
rm -rf Calculator-Web-Application
git clone https://github.com/Anil9098/Calculator-Web-Application.git
cd Calculator-Web-Application || { echo "Failed to enter directory"; exit 1; }
                
# Additional commands you want to run on EC2
docker kill app-container
docker system prune -a -f
echo "Building Docker image..."
docker build -t web_application:latest . || { echo "Docker build failed"; exit 1; }
                
# Running Docker container
docker run -d -p 5000:5000 --name app-container web_application:latest || { echo "Docker run failed"; exit 1; }

EOF








