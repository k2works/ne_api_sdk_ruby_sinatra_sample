# A sample Gemfile
source "https://rubygems.org"

gem "bootstrap-sass"
gem "compass"
gem "sinatra"
gem "sinatra-contrib"
gem "ne_api_sdk_ruby", github: "k2works/ne_api_sdk_ruby"

group :development do
   gem 'thin'
   gem 'guard'
   gem 'guard-livereload'
   gem 'rack-livereload'
end
      
group :development, :test do
  gem 'pry'
  gem 'rspec'  
end

group :test do
  gem 'rack-test'
  gem 'capybara'
  gem 'launchy'
  gem 'selenium-webdriver'
end
