FROM ruby:3.3.7
LABEL maintainer="cguess@gmail.com"

# Install dependencies
RUN apt-get update
# vips etc
RUN apt-get install -y build-essential libvips-dev
# nodejs
RUN curl -sL https://deb.nodesource.com/setup_18.x | bash -
RUN apt-get install -y nodejs

RUN npm install --global yarn

COPY . /app
WORKDIR /app

RUN bundle install
RUN yarn install

RUN bundle exec rails assets:precompile

# We're assuming that the database is already created when deployed, but I'm putting this here for reference
# Instead we'll be doing it in the entypoint script
# RUN bundle exec rails db:migrate
# RUN bundle exec rails db:seed

EXPOSE 3000

ENTRYPOINT ["./docker-entrypoint.sh"]
