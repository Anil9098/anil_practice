#!/bin/bash

set -e

#Parameters given 

REPO_URL=$1
TAG=$2
IMAGE_NAME=$3
CONTAINER_NAME=$4
PORT=$5

#Check if all arguments are provided

if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ] || [ -z "$4" ]; then
  echo "Usage: $0 <repo_url> <tag> <image_name> <container_name>"
  exit 1
fi

#Output the parameters :

echo "Repository URL: $REPO_URL"
echo "Docker Image Name: $IMAGE_NAME"
echo "Docker Image Tag: $TAG"
echo "Docker Container Name: $CONTAINER_NAME"
echo "Docker Container Port Mapping : $PORT"


#Step 1: Navigate to the project directory
REPO_DIR=$(basename "$1" .git)


#Step 2: Checking Repository exists or not 
if [ -d "$REPO_DIR" ]; then
  echo "Repository already exists. Pulling latest changes"
  cd "$REPO_DIR"
  git pull
else
  echo "Cloning repository from $REPO_URL"
  git clone "$REPO_URL"
  cd "$REPO_DIR"
fi


#Step 3: Build the Docker image
echo "Building Docker image with tag $2"
docker build -t $3:$2 . || { echo "Failed to build Docker image"; exit 1; }


#Step 4: Check if container is running with the same image
echo "Checking if container with image $3:$2 is running"
RUNNING_CONTAINER=$(docker ps --filter "ancestor=$3:$2" --filter "name=$4" -q)


if [ ! -z "$RUNNING_CONTAINER" ]; then
  echo "Container with name $4 is already running.Stopping and removing"
  docker stop $RUNNING_CONTAINER || { echo "Failed to stop container"; exit 1; }
  docker rm $RUNNING_CONTAINER || { echo "Failed to remove container"; exit 1; }
else
  echo "No running container found with the name $4"
fi


if [ $(docker ps -a -q -f name=$4) ]; then
    echo "Container $4 exists. Stopping and removing it"
    docker stop $4
    docker rm $4
fi

#Step 5: Run the container with the new image
echo "Running container $4 with image $3:$2"
docker run -d -p "$PORT:$PORT" --name $4 $3:$2 || { echo "Failed to run container"; exit 1; }

echo "Container $4 is now running with image $3:$2"
docker ps

