source 'https://rubygems.org'

gem 'rails', '4.1.8'
gem 'mysql2'
gem 'sass-rails', '~> 4.0.3'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'therubyracer',  platforms: :ruby

gem 'jquery-rails'
gem 'jbuilder', '~> 2.0'
gem 'sdoc', '~> 0.4.0',          group: :doc
gem 'spring',        group: :development

gem 'unicorn'

gem "faye", require: false
gem "devise"
gem "cancan"
gem "figaro"
gem "haml-rails"
gem "simple_form"


group :assets do
  gem 'bootstrap-sass', '~> 3.3.1'
  gem 'autoprefixer-rails'
  gem 'angularjs-rails'
  gem 'font-awesome-sass'
  gem 'haml_coffee_assets'
  gem "quiet_assets"
end

group :api do
  gem 'gitlab'
end

group :development, :test do
  gem "guard"
  gem "guard-rspec"
  gem "pry"
  gem "rspec-rails"
  gem 'factory_girl_rails'
  gem "better_errors"
  gem "binding_of_caller"
  gem 'shoulda-matchers', require: false
end

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]
