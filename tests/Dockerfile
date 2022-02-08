FROM ruby:2.6.0

WORKDIR /
EXPOSE 4567

RUN gem install bundler
RUN bundle install
COPY . /
CMD ['rspec', 'api_get_locations_spec.rb']