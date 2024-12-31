#!/bin/bash

# Script to build and update a specific Docker Compose service without downtime and clean up unused resources

set -e

# Function to update a service with a new build
deploy_service_with_new_image() {
  SERVICE=$1
  echo "Starting deployment for service: $SERVICE with a new image."

  # Build the new image for the specified service
  docker-compose build $SERVICE
  echo "$SERVICE image build completed."

  # Stop and remove the old container
  docker-compose stop $SERVICE
  docker-compose rm -f $SERVICE
  echo "$SERVICE container stopped and removed."

  # Start the new container
  docker-compose up -d $SERVICE
  echo "$SERVICE updated successfully with the new image and is now running."

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
read -p "Enter the service name to update with a new image: " service_name

# Validate input
if echo "$services" | grep -q "^$service_name$"; then
  deploy_service_with_new_image $service_name
else
  echo "Error: Service '$service_name' not found."
  exit 1
fi

# Script completed
echo "Deployment completed for service: $service_name"
