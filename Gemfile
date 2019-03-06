source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.0.7', '>= 5.0.7.1'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 3.0'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'jquery-rails'

gem 'devise', :github => 'plataformatec/devise', :branch => 'master'
gem 'bootstrap-sass', ">= 3.4.1"
gem 'font-awesome-sass', '~> 4.4.0'
gem 'kaminari'
gem 'carrierwave'
gem 'mini_magick'
gem 'remotipart', '~> 1.2'
gem 'pundit'
gem 'haml-rails'
gem 'kaminari'
gem 'active_model_otp', '~> 1.2'
gem 'rotp', '~> 4.0', '>= 4.0.2'
gem 'active_model_serializers', "~> 0.8.0"
gem 'jwt'

group :development, :test do
  gem 'byebug', platform: :mri
  gem 'erb2haml'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
