FROM ruby:3.1.0
ARG precompileassets

RUN apt-get update && apt-get install -y curl gnupg

RUN apt-get -y update && \
      apt-get install --fix-missing --no-install-recommends -qq -y \
        build-essential \
        vim \
        wget gnupg \
        git-all \
        curl \
        ssh \
        libpq5 libpq-dev -y && \
      wget -qO- https://deb.nodesource.com/setup_16.x  | bash - && \
      apt-get install -y nodejs && \
      wget -qO- https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
      echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
      apt-get update && \
      apt-get install yarn && \
      apt-get clean && \
      rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN gem install bundler
#Install gems
RUN mkdir /gems
WORKDIR /gems
COPY Gemfile .
COPY Gemfile.lock .
COPY .ruby-version .
COPY package.json .
RUN bundle install
RUN yarn install

ARG INSTALL_PATH=/opt/webauthnrailsdemo
ENV INSTALL_PATH $INSTALL_PATH
WORKDIR $INSTALL_PATH
COPY . .

RUN scripts/potential_asset_precompile.sh $precompileassets