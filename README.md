# Bit-integrations-Docker

## Table of Contents

- [Introduction](#introduction)
- [Docker Services](#docker-services)
- [Requirements](#requirements)
- [Stop & Remove all the containers (optional)](#stop--remove-all-the-containers-optional)
- [Installation](#installation)
- [File Overview](#file-overview)
- [Setup Bit-integrations App and Web for HTTPS](#setup-bit-integrations-app-and-web-for-https)
- [Setup Bit-integrations App and Web for SSH](#setup-bit-integrations-app-and-web-for-ssh)
- [Browser Access](#browser-access)
- [Stopping Services](#stopping-services)

## Introduction

Bit-integrations-Docker is a Docker-based shopify project for running the Bit-integrations application and web services. php version 8.2 used. It provides a convenient way to set up and run these services using Docker containers.

## Docker Services

- nginx
- app
- admin
- web
- worker
- database
- redis
- certbot
- mailpit (development)

## Requirements

- Docker
- Docker Compose

## Stop & Remove all the containers (optional)

To stop and remove all Docker containers, you can run the following commands:

```shell
docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)
```

## Installation

1. Clone the Bit-integrations-Docker project and navigate to the project directory:

   HTTPS:

   ```shell
   git clone https://github.com/JoulesLabs/bit-integrations-docker.git
   cd bit-integrations-docker
   #or
   git clone https://github.com/JoulesLabs/bit-integrations-docker.git ./
   ```

   SSH:

   ```shell
   git clone git@github.com:JoulesLabs/bit-integrations-docker.git
   cd bit-integrations-docker
   #or
   git clone git@github.com:JoulesLabs/bit-integrations-docker.git ./
   ```

## File Overview

The project structure looks like this:

```shell
bit-integrations-docker
├── .docker
├── app
│   └── all app files
├── admin
│   └── all admin files
├── web
│   └── all web files
├── .dockerignore
├── .gitignore
├── .env
├── docker-compose.yml.example
├── deploy
├── README.md
└── make-ssl.sh.example
```

## Nginx Cconfigureation port, depends_on, networks

Check your `docker-compose.yml`, `nginx service` block, and configure your `volumes` so that local setup files are mounted inside the Docker `nginx` container. configure your port, depends_on, networks for local, staging, prod.

```shell
    volumes:
      - ./.docker/nginx/nginx.conf:/etc/nginx/nginx.conf
      - ./.docker/nginx/app/local.conf:/etc/nginx/conf.d/admin.conf
      - ./.docker/nginx/admin/local.conf:/etc/nginx/conf.d/admin.conf
      - ./.data/nginx/logs:/var/log/nginx
      - ./app:/var/www/app
      - ./admin:/var/www/admin
      # - ./.data/certs/certbot/conf:/etc/letsencrypt # uncomment when production deploy
      # - ./.data/certs/certbot/www:/var/www/certbot # uncomment when production deploy
    ports:
      - "80:80"
      # - "443:443" # uncomment when production deploy
    depends_on:
      - app
      - web
    networks:
      - bit_integration_network
    environment:
      - X_SERVER_TYPE=nginx
```

## Setup Bit-integrations App,Web and admin for HTTPS

To set up Bit-integrations App,Web and admin, follow these steps:

```shell
git clone https://github.com/JoulesLabs/bit-integrations-app.git app
git clone https://github.com/JoulesLabs/bit-integrations-web.git web
git clone https://github.com/JoulesLabs/bit-integrations-admin.git admin
cp docker-compose.yml.example docker-compose.yml
cd app
cp .env.example .env && cd ..
cd web
cp .env.example .env && cd ..
cd admin
cp .env.example .env && cd ..
docker-compose build
docker-compose up -d
docker-compose ps -a
## for app
docker-compose exec app composer install
docker-compose exec app php artisan migrate:fresh --seed
docker-compose exec app chmod 777 -R ./storage/logs/
## for admin
docker-compose exec admin composer install
docker-compose exec admin php artisan migrate:fresh --seed
docker-compose exec admin chmod 777 -R ./storage/logs/
## for web
sudo ./deploy
```

## Setup Bit-integrations App,Web and admin for SSH

To set up Bit-integrations App,Web and admin for SSH, follow these steps:

```shell
git clone git@github.com:JoulesLabs/bit-integrations-app.git app
git clone git@github.com:JoulesLabs/bit-integrations-web.git web
git clone git@github.com:JoulesLabs/bit-integrations-admin.git admin
cp docker-compose.yml.example docker-compose.yml
cd app
cp .env.example .env && cd ..
cd web
cp .env.example .env && cd ..
cd admin
cp .env.example .env && cd ..
docker-compose up -d --build
docker-compose ps -a
## for app
docker-compose exec app composer install
docker-compose exec app php artisan migrate:fresh --seed
docker-compose exec app chmod 777 -R ./storage/logs/
## for admin
docker-compose exec admin composer install
docker-compose exec admin php artisan migrate:fresh --seed
docker-compose exec admin chmod 777 -R ./storage/logs/
## for web
sudo ./deploy
```

## Browser Access

Finally, access the services in your browser at `http://localhost:80` or `http://example.com`.

## Stopping Services

To stop all the services, run the command:

```shell
docker-compose down
```

## Set up Ngrok for Local to Public Access

Copy your `.env.example` file to `.env` file

```shell
NGROK_AUTH=
NGROK_DOMAIN=
```

Make sure you have access from local to public by using `Ngrok`. You must have an `Ngrok account` First, set up the `environment` variables `NGROK_AUTH=` and `NGROK_DOMAIN=`. and commnent out docker-compose.yml `service` block `ngrok`.

### Customization

- Replace `https://github.com/yourusername/yourrepository.git` with your actual repository URL.
- Adjust the directory structure and paths in the instructions if they differ.
