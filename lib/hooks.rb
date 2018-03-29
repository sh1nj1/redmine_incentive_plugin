module RedmineIncentivePlugin

  CUSTOM_FIELD_ID__XP = 8
  CUSTOM_FIELD_ID__SP = 2

  class Hooks < Redmine::Hook::ViewListener
    def controller_issues_edit_after_save(context={})

      issue = context[:issue]

      # duplicated codes
      userXpMap = Hash.new(0) # each item's default value is 0
      userSpMap = Hash.new(0)
      userHoursMap = Hash.new(0)
      sp = issue.custom_value_for(CUSTOM_FIELD_ID__SP).to_s.to_f
      total = issue.total_spent_hours
      issue.time_entries.map do |time_entry|
        userSp = sp * 1000 * (time_entry.hours / total)
        user = time_entry.user
        userXp = time_entry.user.custom_value_for(CUSTOM_FIELD_ID__XP)
        userXpMap[user] = userXp.value.to_s.to_f
        userSpMap[user] = userSpMap[user] + userSp
        userHoursMap[user] = userHoursMap[user] + time_entry.hours
      end
      # end of duplicated codes

      issue = context[:issue]
      if issue.status.is_closed?
        userSpMap.each do |user, sp|
          userXp = user.custom_value_for(CUSTOM_FIELD_ID__XP)
          userXp.value = (userXpMap[user] + sp.round).round
          userXp.save
        end
      end
    end

    def view_issues_show_details_bottom(context={})

      issue = context[:issue]

      userXpMap = Hash.new(0) # each item's default value is 0
      userSpMap = Hash.new(0)
      userHoursMap = Hash.new(0)
      #if ! issue.status.is_closed?
        sp = issue.custom_value_for(CUSTOM_FIELD_ID__SP).to_s.to_f
        total = issue.total_spent_hours
        issue.time_entries.map do |time_entry|
          userSp = sp * 1000 * (time_entry.hours / total)
          user = time_entry.user
          userXp = time_entry.user.custom_value_for(CUSTOM_FIELD_ID__XP)
          userXpMap[user] = userXp.value.to_s.to_f
          userSpMap[user] = userSpMap[user] + userSp
          userHoursMap[user] = userHoursMap[user] + time_entry.hours
        end
      #end

      context[:userSpMap] = userSpMap
      context[:userXpMap] = userXpMap
      context[:userHoursMap] = userHoursMap
      context[:controller].send(:render_to_string, {
          :partial => "hooks/redmine_incentive_plugin/view_issues_form_details_bottom",
          :locals => context
      })
    end
  end
end
