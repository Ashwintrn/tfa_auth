FROM ruby:3.2.2
RUN apt-get update

ADD . /Rails-Docker
WORKDIR /Rails-Docker

RUN gem install bundler
# RUN bundle config set force_ruby_platform true
RUN bundle install
EXPOSE 3000
CMD ["bash"]