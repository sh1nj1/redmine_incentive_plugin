require 'redmine'

if (Rails.configuration.respond_to?(:autoloader) && Rails.configuration.autoloader == :zeitwerk) || Rails.version > '7.0'
  Rails.autoloaders.each { |loader| loader.ignore(File.dirname(__FILE__) + '/lib') }
end
require File.dirname(__FILE__) + '/lib/redmine_incentive_plugin/user_patch'
require File.dirname(__FILE__) + '/lib/redmine_incentive_plugin/hooks'

Redmine::Plugin.register :redmine_incentive_plugin do
  name 'Redmine Incentive Plugin'
  author 'soonoh'
  description 'Simple incentive system with custom fields and time log'
  version '1.0.0'
  url 'https://github.com/sh1nj1/redmine_incentive_plugin'
  author_url ''


  settings :partial => 'redmine_incentive_plugin/settings',
           :default => {
             :display_xp_in_user_format => true,
             :custom_field_id__xp => ' ',
             :custom_field_id__sp => ' ',
             :user_point_expression => RedmineIncentivePlugin::DEFAULT_USER_POINT_EXPRESSION
           }
end
