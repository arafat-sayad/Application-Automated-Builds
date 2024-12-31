#!/bin/bash

# Script to update a specific Docker Compose service without downtime

set -e

# Function to update a service
deploy_service() {
  SERVICE=$1
  echo "Starting deployment for service: $SERVICE"

  # Build the new image for the specified service
  docker-compose build $SERVICE
  echo "$SERVICE image build completed."

  # Stop and remove the old container
  docker-compose stop $SERVICE
  docker-compose rm -f $SERVICE
  echo "$SERVICE container stopped and removed."

  # Start the new container
  docker-compose up -d $SERVICE
  echo "$SERVICE updated successfully and is now running."
}

# Function to pull the latest image for a service
update_latest_image() {
  SERVICE=$1

  # Extract the image name for the service
  IMAGE=$(docker-compose config | awk -v service="$SERVICE" '$1 == service ":" {getline; print $2}')
  if [ -z "$IMAGE" ]; then
    echo "Error: No image found for service $SERVICE. Check docker-compose.yml."
    exit 1
  fi

  echo "Pulling latest image for $SERVICE: $IMAGE"

  # Pull the latest image
  docker-compose pull $SERVICE

  # Stop and remove the old container
  docker-compose stop $SERVICE
  docker-compose rm -f $SERVICE

  # Start a new container with the latest image
  docker-compose up -d $SERVICE
  echo "$SERVICE updated with the latest image."
}

# List all available services
echo "Available services:"
services=$(docker-compose config --services)
echo "$services"

# Get user input for service to update
read -p "Enter the service name to update: " service_name

# Validate input
if echo "$services" | grep -q "^$service_name$"; then
  # Ask user whether to update the service
  read -p "Do you want to update the service image (yes/no)? " update_choice
  if [ "$update_choice" == "yes" ]; then
    update_latest_image $service_name
  else
    deploy_service $service_name
  fi
else
  echo "Error: Service '$service_name' not found."
  exit 1
fi

# Script completed
echo "Deployment completed for service: $service_name"
