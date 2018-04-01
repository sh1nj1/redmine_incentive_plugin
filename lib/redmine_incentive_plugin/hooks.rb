module RedmineIncentivePlugin

  def self.userScoresMap(issue)

    xpId = Setting.plugin_redmine_incentive_plugin['custom_field_id__xp'].to_i
    spId = Setting.plugin_redmine_incentive_plugin['custom_field_id__sp'].to_i

    userXpMap = Hash.new(0) # each item's default value is 0
    userSpMap = Hash.new(0)
    userHoursMap = Hash.new(0)

    sp = issue.custom_value_for(spId).to_s.to_f
    total = issue.total_spent_hours

    issue.time_entries.map do |time_entry|
      userSp = sp * 1000 * (time_entry.hours / total)
      user = time_entry.user
      userXpValue = user.custom_value_for(xpId)
      if userXpValue.nil?
        user.custom_field_values = {xpId=>0}
        user.save_custom_field_values
        userXpValue = user.custom_value_for(xpId)
      end
      if userXpValue
        userXpMap[user] = userXpValue.value.to_s.to_f
        userSpMap[user] = userSpMap[user] + userSp
        userHoursMap[user] = userHoursMap[user] + time_entry.hours
      end
    end
    {:userSpMap => userSpMap, :userXpMap => userXpMap, :userHoursMap => userHoursMap}
  end

  class Hooks < Redmine::Hook::ViewListener

    def controller_issues_edit_before_save(context={})

      issue = context[:issue]
      oldIssue = Issue.find_by_id(issue.id)

      if oldIssue.status.id == issue.status.id
        return
      end
      isPlusPoint = (!oldIssue.status.is_closed? and issue.status.is_closed?)
      isMinusPoint = (oldIssue.status.is_closed? and !issue.status.is_closed?)
      operator = 0
      if isPlusPoint
        operator = 1
      elsif isMinusPoint
        operator = -1
      end

      xpId = Setting.plugin_redmine_incentive_plugin['custom_field_id__xp'].to_i

      userScoresMap = RedmineIncentivePlugin::userScoresMap issue
      userXpMap = userScoresMap[:userXpMap]
      userSpMap = userScoresMap[:userSpMap]

      userSpMap.each do |user, sp|
        userXp = user.custom_value_for(xpId)
        userXp.value = (userXpMap[user] + (sp.round * operator)).round
        userXp.save
      end
    end

    def view_issues_show_details_bottom(context={})

      issue = context[:issue]

      context.merge!(RedmineIncentivePlugin::userScoresMap(issue))

      context[:controller].send(:render_to_string, {
          :partial => "redmine_incentive_plugin/hooks/view_issues_form_details_bottom",
          :locals => context
      })
    end
  end
end
