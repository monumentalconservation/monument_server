FROM ruby:2.5
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client
RUN mkdir /monument_server
WORKDIR /monument_server
COPY Gemfile /monument_server/Gemfile
COPY Gemfile.lock /monument_server/Gemfile.lock
RUN bundle install
COPY . /monument_server

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]