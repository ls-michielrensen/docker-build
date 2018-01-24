FROM circleci/php:5.6

# Packages
RUN sudo apt-get update && sudo apt-get install -y \
  apt-transport-https \
  gnupg-curl \
  libmcrypt-dev \
  libxml2-dev \
  moreutils \
  mysql-client \
  php5.6-cli \
  vim \
  wget \
  zlib1g-dev \
  --no-install-recommends && sudo rm -r /var/lib/apt/lists/* \
  && sudo docker-php-ext-install mcrypt soap zip \
  && sudo docker-php-ext-enable mcrypt soap zip

# Composer
ENV COMPOSER_VERSION 1.4.2
RUN curl -sS https://getcomposer.org/installer | sudo php -- --version="${COMPOSER_VERSION}" --install-dir="/usr/local/bin" --filename="composer"

# NVM
ENV NODE_VERSION 8.9.1
ENV YARN_VERSION 1.3.2
COPY nvm.sh /etc/profile.d/nvm.sh
RUN sudo git clone https://github.com/creationix/nvm.git /opt/nvm; \
  sudo mkdir -p /usr/local/node /usr/local/nvm && \
  sudo chmod 0777 -R /usr/local/nvm; sudo chmod 0777 -R /usr/local/node; \
  . /etc/profile.d/nvm.sh && \
  nvm install $NODE_VERSION && \
  nvm use $NODE_VERSION && \
  nvm alias default $NODE_VERSION && \
  nvm version && \
  npm install -g yarn@${YARN_VERSION}

# Codacy Code Coverage
RUN composer global require codacy/coverage
COPY composer.sh /etc/profile.d/composer.sh

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoints.sh

ENTRYPOINT ["docker-entrypoints.sh"]
