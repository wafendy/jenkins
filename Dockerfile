FROM ruby:2.4.1

ENV APP_ROOT /app
ENV BUNDLE_PATH /bundle

RUN apt-get update && apt-get install -y nodejs mysql-client build-essential

RUN mkdir /bundle

RUN mkdir $APP_ROOT
WORKDIR $APP_ROOT
ADD Gemfile /app/Gemfile
ADD Gemfile.lock /app/Gemfile.lock

RUN bundle check || bundle install

ADD . $APP_ROOT
