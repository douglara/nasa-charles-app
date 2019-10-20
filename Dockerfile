FROM ruby:2.5.3

RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - \
        && apt-get install -y nodejs yarn  && npm install --global yarn

RUN apt-get update -qq \
    && apt-get install -y \
        build-essential libpq-dev nodejs \
        postgresql postgresql-client \
        graphviz

RUN mkdir /app
WORKDIR /app

COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock

RUN gem install bundler
RUN bundle install

COPY . /app

EXPOSE 3000

CMD bundle exec rails s -p 3000 -b '0.0.0.0'
