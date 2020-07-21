FROM ruby:2.7.1-alpine3.12

RUN apk update
RUN gem update bundler

#Using japanese on Rails console
ENV LANG ja_JP.UTF-8

# SETUP middleware required for build
# build-base     : native extension build
# mariadb-dev    : gem mysql2
# mariadb-client : MySQL connection client
# nodejs         : JavaScript runtime library
RUN apk --update add --virtual build-deps \
        build-base \
        mariadb-dev \
        mariadb-client \
        nodejs \
        tzdata \
        git \
    && rm -rf /usr/lib/libmysqld* \
    && rm -rf /usr/bin/mysql*

RUN mkdir /rails_devise_sample
ENV APP_ROOT /rails_devise_sample
WORKDIR $APP_ROOT

# Copy Gemfile of host to gest
COPY ./Gemfile $APP_ROOT/Gemfile
COPY ./Gemfile.lock $APP_ROOT/Gemfile.lock

# Run bundle install
RUN bundle install --jobs=4

# Copy from source files
COPY . $APP_ROOT
