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
        # look for our custom field in the database
        #
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
        format = name_formatter_without_xp_format(formatter)
        displayXp = Setting.plugin_redmine_incentive_plugin['display_xp_in_user_format'].to_i == 1
        if ! format[:string].ends_with? USER_FORMAT_SCORE and displayXp
          format[:string] = format[:string] + USER_FORMAT_SCORE
        end
        if format[:string].ends_with? USER_FORMAT_SCORE and !displayXp
          format[:string].slice! USER_FORMAT_SCORE
        end
        format
      end
    end
  end

  # include our patch
  User.send(:include, UserPatch)

end