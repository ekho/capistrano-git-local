capistrano-git-local
=================================

Git scm which works on local for Capistrano 3

[![Gem Version](https://badge.fury.io/rb/capistrano-git-local.svg)](http://badge.fury.io/rb/capistrano-git-local)

Capfile
```ruby
require 'capistrano/git-local'
```

Gemfile
```ruby
gem 'capistrano-git-local', '~> 0.1', :github => 'i-ekho/capistrano-git-local'
```
OR
```ruby
source 'https://rubygems.org'
gem 'capistrano-git-local', '~> 0.1'
```

deploy.rb
```ruby
set :scm, :git_local
```
