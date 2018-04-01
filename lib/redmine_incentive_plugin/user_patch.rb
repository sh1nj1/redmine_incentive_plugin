require_dependency "user"

module RedmineIncentivePlugin

  module UserPatch

    USER_FORMAT_SCORE = ' (#{!xp.to_s.empty? ? xp.to_s : "0"})'

    def self.included(base)
      base.send(:include, InstanceMethods)

      base.class_eval do
        unloadable # Send unloadable so it will not be unloaded in development

        extend ClassMethods

        class << self
          # This line is responsible for letting redmine call name_formatter_with_xp_format
          # defined below instead of User::name_formatter
          alias_method_chain :name_formatter, :xp_format
        end
      end
    end

    module InstanceMethods
      # This method will be included in the User-class to retrieve the field value of your custom field
      def xp
        xpId = Setting.plugin_redmine_incentive_plugin['custom_field_id__xp'].to_i

        cf = CustomField.find_by_id(xpId)
        if cf
          # get the value for the custom field (the method is provided by act_as_customizable behavior plugin)
          custom_value_for(cf)
        else
          "0"
        end
      end
    end

    module ClassMethods

      def name_formatter_with_xp_format(formatter = nil)
        displayXp = Setting.plugin_redmine_incentive_plugin['display_xp_in_user_format'].to_i == 1
        format = name_formatter_without_xp_format(formatter)
        formatIncluded = format[:string].ends_with? USER_FORMAT_SCORE
        if !formatIncluded and displayXp
          format[:string] += USER_FORMAT_SCORE
        end
        if formatIncluded and !displayXp
          format[:string].slice! USER_FORMAT_SCORE
        end
        format
      end
    end
  end

  User.send(:include, UserPatch)

end