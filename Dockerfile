# Base image:
FROM starefossen/ruby-node:latest

RUN apt-get install -y libsqlite3-dev
RUN apt-get install -y libcurl3 libcurl3-gnutls libcurl4-openssl-dev

RUN mkdir -p /zalupaka

WORKDIR /zalupaka

ADD Gemfile /zalupaka/Gemfile
ADD Gemfile.lock /zalupaka/Gemfile.lock

RUN bundle install

ADD package.json /zalupaka/package.json

RUN yarn install

ADD yarn.lock /zalupaka/yarn.lock

ADD . /zalupaka

RUN RAILS_ENV=production bundle exec rake assets:precompile

RUN rm -rf /zalupaka/tmp/* /zalupaka/log/*

# This is because base image is setting this - needs to be fixed in image
RUN unset VERSION

EXPOSE 3000