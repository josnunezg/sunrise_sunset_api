# syntax=docker/dockerfile:1
# check=error=true

# This Dockerfile is designed for production, not development. Use with Kamal or build'n'run by hand:
# docker build -t sunrise_sunset .
# docker run -d -p 80:80 -e RAILS_MASTER_KEY=<value from config/master.key> --name sunrise_sunset sunrise_sunset

# For a containerized dev environment, see Dev Containers: https://guides.rubyonrails.org/getting_started_with_devcontainer.html

# Make sure RUBY_VERSION matches the Ruby version in .ruby-version
ARG RUBY_VERSION=3.2.2
FROM docker.io/library/ruby:$RUBY_VERSION-slim AS base

# Variables necesarias
ENV LANG=C.UTF-8 \
    BUNDLER_VERSION=2.5.6

# Instalación de paquetes básicos
RUN apt-get update -qq && \
    apt-get install -y build-essential libpq-dev nodejs

# Directorio de trabajo
WORKDIR /app

# Copiar gems primero para aprovechar cache de Docker
COPY Gemfile Gemfile.lock ./

RUN gem install bundler -v "$BUNDLER_VERSION"
RUN bundle install

# Copiar el resto del proyecto
COPY . .

# Exponer puerto Rails por defecto
EXPOSE 3000

CMD ["bash"]

