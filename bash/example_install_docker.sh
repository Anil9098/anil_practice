#!/bin/bash

#Checking Docker is installed or not
if command -v docker &> /dev/null
then
    echo "Docker is already installed"
else
    echo "Docker is not installed.Installing Docker"

    # Uninstall old versions of Docker if they exist
    sudo apt-get remove -y docker docker-engine docker.io containerd runc

    # Update the package list
    sudo apt-get update -y

    # Install dependencies
    sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common

    # Adding Docker official GPG key
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

    # Add Docker repository to APT sources
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

    # Update package list again to include Docker repository
    sudo apt-get update -y

    # Install Docker (Community Edition)
    sudo apt-get install -y docker-ce

    # Start Docker service
    sudo systemctl start docker

    # Enable Docker to start on boot
    sudo systemctl enable docker

    echo "Docker installed successfully"
    
    # Optional: Add user to the Docker group to avoid using sudo with docker commands
    sudo usermod -aG docker $USER
    echo "User added to Docker group.You may need to log out and log back in for this change to take effect."

fi

# Verify Docker installation
docker --version

docker ps




