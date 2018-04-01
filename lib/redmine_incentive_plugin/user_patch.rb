require_dependency "user"

module RedmineIncentivePlugin

  module UserPatch

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
        cf = CustomField.find_by_id(CUSTOM_FIELD_ID__XP)
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
        # TODO: this needs to be optional
        if ! format[:string].ends_with? ")"
          format[:string] = format[:string] + ' (#{!xp.to_s.empty? ? xp.to_s : "0"})'
        end
        format
      end
    end
  end

  # include our patch
  User.send(:include, UserPatch)

end