source 'https://rubygems.org'
ruby '2.3.4'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.5'
# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development
gem 'bcrypt', '~> 3.1.7'
gem 'jwt', '~> 1.5'
gem 'pg', '~> 0.18'
gem 'puma', '~> 3.7'
gem 'rack-cors'
gem 'rails', '~> 5.1.3'

group :development, :test do
  gem 'capybara'
  gem 'database_cleaner'
  gem 'factory_girl_rails'
  gem 'faker', '~> 1.7'
  gem 'rspec-rails'
  gem 'terminal-notifier-guard'
  gem 'shoulda-matchers'
end

group :development do
  gem 'better_errors'
  gem 'foreman'
  gem 'guard-ctags-bundler'
  gem 'guard-rspec'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'rubocop'
  gem 'the_shocker'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
