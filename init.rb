require 'redmine'
require 'redmine_incentive_plugin/user_patch'
require 'redmine_incentive_plugin/hooks'

Redmine::Plugin.register :redmine_incentive_plugin do
  name 'Redmine Incentive Plugin'
  author 'chk0ndanger'
  description 'Simple incentive system with custom fields and time log'
  version '0.1.0'
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
