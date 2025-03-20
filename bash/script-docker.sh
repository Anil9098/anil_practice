#!/bin/bash

#Parameters

REPO_URL="https://github.com/Anil9098/Calculator-Web-Application.git"        
TAG="latest"              
IMAGE_NAME="web-application"       
CONTAINER_NAME="app-container"    

# Check if all arguments are provided
if [ -z "$REPO_URL" ] || [ -z "$TAG" ] || [ -z "$IMAGE_NAME" ] || [ -z "$CONTAINER_NAME" ]; then
  echo "Usage: $0 <repo_url> <tag> <image_name> <container_name>"
  exit 1
fi

# Step 1: Clone the repository
echo "Cloning repository from $REPO_URL..."
git clone $REPO_URL || { echo "Failed to clone repository"; exit 1; }

# Step 2: Navigate to the project directory (assuming the repo is cloned as the repo name)
REPO_DIR=$(basename "$REPO_URL" .git)
cd $REPO_DIR || { echo "Failed to change to directory $REPO_DIR"; exit 1; }


# Step 3: Build the Docker image
echo "Building Docker image with tag $TAG..."
docker build -t $IMAGE_NAME:$TAG . || { echo "Failed to build Docker image"; exit 1; }

# Step 4: Check if container is running with the same image
echo "Checking if container with image $IMAGE_NAME:$TAG is running..."
RUNNING_CONTAINER=$(docker ps --filter "ancestor=$IMAGE_NAME:$TAG" --filter "name=$CONTAINER_NAME" -q)

if [ ! -z "$RUNNING_CONTAINER" ]; then
  echo "Container with name $CONTAINER_NAME is already running. Stopping and removing it..."
  docker stop $RUNNING_CONTAINER || { echo "Failed to stop container"; exit 1; }
  docker rm $RUNNING_CONTAINER || { echo "Failed to remove container"; exit 1; }
else
  echo "No running container found with the name $CONTAINER_NAME."
fi


if [ $(docker ps -a -q -f name=$CONTAINER_NAME) ]; then
    echo "Container $CONTAINER_NAME exists. Stopping and removing it..."
    docker stop $CONTAINER_NAME
    docker rm $CONTAINER_NAME
fi


# Step 5: Run the container with the new image
echo "Running container $CONTAINER_NAME with image $IMAGE_NAME:$TAG..."
docker run -d -p 5000:5000 --name $CONTAINER_NAME $IMAGE_NAME:$TAG || { echo "Failed to run container"; exit 1; }

echo "Container $CONTAINER_NAME is now running with image $IMAGE_NAME:$TAG."



