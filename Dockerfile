FROM circleci/php:7.2-apache-node-browsers-legacy

# Packages
RUN sudo apt-get update && sudo apt-get install -y \
  apt-transport-https \
  curl \
  gnupg1-curl \
  libmcrypt-dev \
  libxml2-dev \
  moreutils \
  mysql-client \
  vim \
  wget \
  zlib1g-dev \
  libpng-dev \
  --no-install-recommends && sudo rm -r /var/lib/apt/lists/* \
  && sudo docker-php-ext-install soap zip gd \
  && curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.8/install.sh | bash

# Composer
RUN  composer global require codacy/coverage "phpunit/phpunit:7.3.*" "sensiolabs/security-checker:^3.0"

# NVM
RUN export NVM_DIR="$HOME/.nvm" \
  && [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" \
  && [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" \
  && nvm install 8.9.1

# AWS
RUN sudo apt-get update && \
  sudo apt-get install python3 && \
  curl https://bootstrap.pypa.io/get-pip.py -o ~/get-pip.py && \
  python ~/get-pip.py --user && \
  ~/.local/bin/pip install awscli --upgrade --user
