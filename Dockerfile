# FROM ruby:2.7.2
# RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
# RUN mkdir /myapp
# WORKDIR /myapp
# COPY Gemfile /myapp/Gemfile
# COPY Gemfile.lock /myapp/Gemfile.lock
# COPY ./.ruby-version /myapp/.ruby-version
# RUN bundle install
# COPY . /myapp

FROM ruby:2.7.2
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
      wget -qO- https://deb.nodesource.com/setup_12.x  | bash - && \
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
RUN bundle install

ARG INSTALL_PATH=/opt/webauthnrailsdemo
ENV INSTALL_PATH $INSTALL_PATH
WORKDIR $INSTALL_PATH
COPY . .

RUN scripts/potential_asset_precompile.sh $precompileassets