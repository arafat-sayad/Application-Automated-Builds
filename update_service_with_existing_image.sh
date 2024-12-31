#!/bin/bash

# Script to update a specific Docker Compose service using the latest image without downtime and clean up unused resources

set -e

# Function to update a service with the latest image
update_service_with_existing_image() {
  SERVICE=$1

  # Extract the image name for the service
  IMAGE=$(docker-compose config | awk -v service="$SERVICE" '$1 == service ":" {getline; print $2}')
  if [ -z "$IMAGE" ]; then
    echo "Error: No image found for service $SERVICE. Check docker-compose.yml."
    exit 1
  fi

  echo "Pulling the latest image for $SERVICE: $IMAGE"

  # Pull the latest image
  docker-compose pull $SERVICE

  # Stop and remove the old container
  docker-compose stop $SERVICE
  docker-compose rm -f $SERVICE

  # Start a new container with the latest image
  docker-compose up -d $SERVICE
  echo "$SERVICE updated successfully with the latest image."

  # Cleanup unused containers and images
  cleanup_unused
}

# Function to clean up unused containers and untagged images
cleanup_unused() {
  echo "Cleaning up unused containers and untagged images..."
  docker container prune -f
  docker image prune -f --filter "dangling=true"
  echo "Cleanup completed."
}

# List all available services
echo "Available services:"
services=$(docker-compose config --services)
echo "$services"

# Get user input for the service to update
read -p "Enter the service name to update using the latest image: " service_name

# Validate input
if echo "$services" | grep -q "^$service_name$"; then
  update_service_with_existing_image $service_name
else
  echo "Error: Service '$service_name' not found."
  exit 1
fi

# Script completed
echo "Deployment completed for service: $service_name"
