require 'redmine'
require 'user_patch'
require 'hooks'

Redmine::Plugin.register :redmine_incentive_plugin do
  name 'Redmine Incentive Plugin plugin'
  author 'Soonoh Jung'
  description 'This is a plugin for Redmine'
  version '0.0.1'
  url 'http://example.com/path/to/plugin'
  author_url 'http://example.com/about'
end

