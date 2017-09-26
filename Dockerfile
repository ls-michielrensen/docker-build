FROM docker as docker

FROM php:5.6-alpine
COPY --from=docker /usr/local/bin /usr/local/bin

# Additionals
RUN apk add --no-cache \
  bash \
  curl \
  git \
  openssl \
  py-pip \
  sudo && \
  pip install docker-compose

RUN apk add --no-cache --virtual build-dependencies \
  binutils-gold \
  g++ \
  gcc \
  libgcc \
  libstdc++ \
  linux-headers \
  make

# PHP
RUN apk --no-cache add \
  libmcrypt-dev \
  libxml2-dev && \
  docker-php-ext-install mcrypt soap zip && \
  docker-php-ext-enable mcrypt soap zip

# Composer
ENV COMPOSER_VERSION 1.4.2
RUN curl -sS https://getcomposer.org/installer | php -- \
  --version="${COMPOSER_VERSION}" \
  --install-dir="/usr/local/bin" \
  --filename="composer" && \
  echo "export PATH=$PATH:/home/build/.composer/vendor/bin" > /etc/profile.d/composer.sh && \
  composer global require codacy/coverage

# Build user
RUN addgroup -S build && adduser -S -g build -g wheel build -h /home/build -s /bin/bash && \
  echo 'build ALL=(ALL) NOPASSWD:ALL' | sudo EDITOR='tee -a' visudo
USER build

# Yarn
ENV NODE_VERSION 6.1.0
ENV YARN_VERSION 0.27.5
ENV SHELL /bin/bash
RUN touch ~/.bashrc && \
  wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.33.4/install.sh | bash && \
  bash -c "source ~/.bashrc && \
  nvm install -s $NODE_VERSION && \
  npm install -g yarn@${YARN_VERSION}" && \
  sudo apk del build-dependencies

WORKDIR /home/build

ENTRYPOINT ["docker-entrypoint.sh"]
