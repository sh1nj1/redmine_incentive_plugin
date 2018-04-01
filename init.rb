require 'redmine'
require 'redmine_incentive_plugin/user_patch'
require 'redmine_incentive_plugin/hooks'

Redmine::Plugin.register :redmine_incentive_plugin do
  name 'Redmine Incentive Plugin'
  author 'Soonoh Jung'
  description 'Simple incentive system with custom fields and time log'
  version '0.0.1'
  url 'http://example.com/path/to/plugin'
  author_url 'http://example.com/about'


  settings :partial => 'redmine_incentive_plugin/settings',
           :default => {
               :display_xp_in_user_format => true,
               :custom_field_id__xp => ' ',
               :custom_field_id__sp => ' '
           }
end

