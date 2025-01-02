#!/bin/bash

set -e

# Function to pull the latest code and restart services
deploy_service() {
  SERVICE=$1
  DIR=$2

  echo "Deploying $SERVICE..."
  cd $DIR

  # Try to pull the latest code
  if git pull origin main; then
    echo "Git pull for $SERVICE succeeded."
  else
    echo "Git pull for $SERVICE failed. Please check for conflicts or issues." >&2
    exit 1
  fi

  # Try to restart the service
  if docker-compose restart $SERVICE; then
    echo "$SERVICE restarted successfully."
  else
    echo "Failed to restart $SERVICE. Please check Docker logs for details." >&2
    exit 1
  fi

  echo "$SERVICE deployment completed successfully."
}

# Deploy the service
SERVICE="app"
DIRECTORY="/sites/project/app"

echo "Deployment process completed!"
