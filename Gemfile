source 'https://rubygems.org'
source 'https://rails-assets.org'

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
gem "unicorn-rails"

gem "faye", require: false

group :auth do
  gem "rolify"
  gem "devise"
  gem "cancan"
end

gem "figaro"
gem "slim-rails"
gem "simple_form", ">= 3.1.0.rc1"


group :assets do
  gem 'bootstrap-sass', '~> 3.3.1'
  gem 'autoprefixer-rails'

  gem 'font-awesome-sass', '~> 4.2.0'
  gem 'haml_coffee_assets'
  gem "quiet_assets"
  gem 'nprogress-rails'

  gem 'angularjs-rails'
  gem 'rails-assets-angular-translate'
end

group :api do
  gem 'gitlab'
end

group :development, :test do
  gem "guard"
  gem "capybara"
  gem 'poltergeist'
  gem "database_cleaner"
  gem "guard-rspec"
  gem 'guard-livereload'
  gem "guard-bundler"
  gem 'guard-rails'
  gem 'pry-rails'
  gem "rspec-rails"
  gem 'factory_girl_rails'
  gem "better_errors"
  gem "binding_of_caller"
  gem 'shoulda-matchers', require: false
  gem "rack-livereload"
end

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]
