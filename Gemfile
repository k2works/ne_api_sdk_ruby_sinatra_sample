# A sample Gemfile
source "https://rubygems.org"

gem 'bootstrap-sass'
gem 'compass'
gem 'font-awesome-sass', '~> 4.3.0'
gem 'sinatra'
gem 'sinatra-contrib'
gem 'coffee-script'
gem 'slim'
gem 'ne_api_sdk_ruby', github: 'k2works/ne_api_sdk_ruby'
gem 'redis'
gem 'dotenv'

group :development do
   gem 'thin'
   gem 'guard'
   gem 'guard-compass'
   gem 'guard-livereload'
   gem 'guard-coffeescript'   
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
