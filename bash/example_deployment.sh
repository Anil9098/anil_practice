#!/bin/bash

set -e


REPO_URL="https://github.com/Anil9098/Calculator-Web-Application.git"
IMAGE_NAME="web-app"
DEFAULT_TAG="latest"
CONTAINER_NAME="web-app-container"

show_help() {

  echo "Usage: $0 [-t tag] [-h help]"
  echo " -t Tag        Specify the Docker image (default: $DEFAULT_TAG)"
  echo " -h,--help     Show the help message"
  exit 0  

}

while getopts ":t:h" opt; do
  case ${opt} in
    t)
      TAG="$OPTARG"  #Set the tag to the argument passed after -t
      ;;
    h)
      show_help  #Show help and exit
      ;;
    \?)
      echo "Invalid option: -$OPTARG" 1>&2
      show_help  # Show help and exit
      ;;
  esac
done

TAG="${TAG:-$DEFAULT_TAG}"

#Output the parameters :
echo "Repository URL: $REPO_URL"
echo "Docker Image Name: $IMAGE_NAME"
echo "Docker Image Tag: $TAG"
echo "Docker Container Name: $CONTAINER_NAME"


#Step 1: Navigate to the project directory
REPO_DIR=$(basename "$REPO_URL" .git)

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
echo "Building Docker image with tag $TAG"
docker build -t $IMAGE_NAME:$TAG . || { echo "Failed to build Docker image"; exit 1; }
              

#Step 4: Check if container is running with the same image
echo "Checking if container with image $IMAGE_NAME:$TAG is running"
RUNNING_CONTAINER=$(docker ps --filter "ancestor=$IMAGE_NAME:$TAG" --filter "name=$CONTAINER_NAME" -q)


if [ ! -z "$RUNNING_CONTAINER" ]; then
  echo "Container with name $CONTAINER_NAME is already running.Stopping and removing"
  docker stop $RUNNING_CONTAINER || { echo "Failed to stop container"; exit 1; }
  docker rm $RUNNING_CONTAINER || { echo "Failed to remove container"; exit 1; }
else
  echo "No running container found with the name $CONTAINER_NAME"
fi


if [ $(docker ps -a -q -f name=$CONTAINER_NAME) ]; then
    echo "Container $CONTAINER_NAME exists. Stopping and removing it"
    docker stop $CONTAINER_NAME
    docker rm $CONTAINER_NAME
fi

#Step 5: Run the container with the new image
echo "Running container $CONTAINER_NAME with image $IMAGE_NAME:$TAG"
docker run -d -p 5000:5000 --name $CONTAINER_NAME $IMAGE_NAME:$TAG || { echo "Failed to run container"; exit 1; }


echo "Container $CONTAINER_NAME is now running with image $IMAGE_NAME:$TAG"
docker ps

echo "Container running successfully"



