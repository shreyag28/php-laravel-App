#!/bin/bash

# Runs inside production server.

# Project directory on server for your project.
export WEB_DIR="/var/www/laravel"
# Your server user. Used to fix permission issue & install our project dependencies
export WEB_USER="ubuntu"

# Change directory to project.
cd $WEB_DIR

# change user owner to ubuntu & fix storage permission issues.
sudo chown -R ubuntu:ubuntu .
sudo chown -R www-data storage
sudo chmod -R u+x .
sudo chmod g+w -R storage

composer -v

# install composer dependencies
sudo -u $WEB_USER composer install --no-dev --no-progress --prefer-dist

# load .env file from AWS Systems Manager
./devops/generate-env.sh

# generate app key & run migrations
sudo -u $WEB_USER php artisan key:generate
sudo -u $WEB_USER php artisan migrate --force --no-interaction
