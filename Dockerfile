FROM ruby:2.2.1
WORKDIR /myapp
ADD Gemfile Gemfile
ADD Gemfile.lock Gemfile.lock
RUN bundle install
ADD . /myapp
EXPOSE 9292