FROM phusion/passenger-ruby24
MAINTAINER Duc Diep

RUN apt-get update \
  && apt-get install -y  libcurl3 libcurl3-gnutls libcurl4-openssl-dev apt-utils git vim sudo

RUN adduser --disabled-password --gecos '' docker
RUN adduser docker sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER docker

ENV HOME /home/docker
ENV HANAMI_HOST=0.0.0.0
ENV HANAMI_ENV=production
RUN chown -R docker:docker /home/docker

ADD . /home/docker
WORKDIR /home/docker

RUN sudo gem install bundler

RUN sudo bundle install --deployment

RUN sudo bundle exec rake assets:precompile
