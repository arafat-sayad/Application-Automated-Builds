# pull official base image
FROM node:18.19.0-alpine

ARG SERVER_ENVIRONMENT
# Add Repositories
RUN rm -f /etc/apk/repositories &&\
    echo "http://dl-cdn.alpinelinux.org/alpine/v3.12/main" >> /etc/apk/repositories && \
    echo "http://dl-cdn.alpinelinux.org/alpine/v3.12/community" >> /etc/apk/repositories

RUN apk update && apk add --no-cache  \
    libzip-dev \
    bzip2-dev \
    libwebp-dev \
    zip \
    bash \
    icu-dev \
    zlib-dev \
    curl-dev \
    git \
    vim

RUN npm install --global pm2
# RUN npm install --global yarn

COPY ./web /usr/src/web

WORKDIR /usr/src/web

# RUN npm install
# RUN yarn cache clean

RUN yarn install -f

RUN yarn build

#EXPOSE 3000


CMD HOST=0.0.0.0 pm2-runtime start yarn --interpreter bash --name web -- preview
#CMD HOST=0.0.0.0 pm2-runtime start yarn --interpreter bash --name web -- start
