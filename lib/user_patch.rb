require_dependency "user"

module UserPatch

  # The available user formats are stored in User::USER_FORMATS (app/models/user.rb)
  # We cannot modify User::USER_FORMATS, as it's a constant
  # Therefore we define an own hash which will be merged with USER_FORMATS
  MY_PLUGIN_USER_FORMATS = {
      :my_custom_name_format => {
          :string => '#{firstname} #{lastname} #{!xp.to_s.empty? ? "("+xp.to_s+")":"00"}',
          :order => %w(firstname lastname id),
          :setting_order => 8
      },
  }

  def self.included(base)
    base.send(:include, InstanceMethods)

    base.class_eval do
      unloadable # Send unloadable so it will not be unloaded in development

      extend ClassMethods

      class << self
        # This line is responsible for letting redmine call name_formatter_with_company_format
        # defined below instead of User::name_formatter
        alias_method_chain :name_formatter, :xp_format
      end
    end
  end

  module InstanceMethods
    # This method will be included in the User-class to retrieve the field value of your custom field
    def xp
      # look for our custom field in the database
      cf = CustomField.where(["name = ?", "XP"]).first
      if cf
        # get the value for the custom field (the method is provided by act_as_customizable behavior plugin)
        custom_value_for(cf)
      else
        "HI"
      end
    end
  end

  module ClassMethods
    # this method is called when formatting user names
    # We change its behavior to additionally look for user formats in our new hash "MY_PLUGIN_USER_FORMATS"
    def name_formatter_with_xp_format(formatter = nil)
      User::MY_PLUGIN_USER_FORMATS[:my_custom_name_format]
    end
  end
end

# include our patch
User.send(:include, UserPatch)