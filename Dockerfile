# run instructions
# docker-compose build
# docker-compose up
# docker-compose run web rails db:create
# ==================

FROM ruby:2.6.3-stretch

LABEL Name=dockerized_rails6 Version=0.1.0
LABEL maintainer="chuks24ng@yahoo.co.uk"


RUN curl -sL https://deb.nodesource.com/setup_12.x | bash - && \
  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
  apt-get update && apt-get install -y \
  build-essential \
  nodejs \
  yarn

ENV APP_HOME /app
RUN mkdir -p ${APP_HOME}
WORKDIR ${APP_HOME}

COPY Gemfile* package.json yarn.lock ./
RUN gem install bundler && \
  yarn install --check-files

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

EXPOSE 3000

CMD ["bundle", "exec", "rails" "server", "-b", "0.0.0.0"]
