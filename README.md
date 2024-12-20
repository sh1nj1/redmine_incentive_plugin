# Redmine Incentive Plugin

Simple incentive system with custom fields and time log.

* Set issue's point
* Log time on Issue
* When the Issue is closing, all contributed users get points.

# Tested redmine version

| plugin version | tested redmine version |
|----------------|------------------------|
| 0.1.0          | 3.2.3, 3.4.4           |
| main           | 6.0.1                  |

# Install

To install this plugin, follow the general Redmine's Plugin installation.

* clone this project to user redmine's plugins directory
* run `rake redmine:plugins:migrate`

# Configuration

After installation, you have to configure the plugin.
Find the plugin in the plugin list and click the Configure link.

[Settings screen]
![Settings Screen](./docs/redmine-incentive-plugin-settings.png)

You have to create two Custom Fields.

* Issue Point
  * float or int type
  * This value is given by Human. A team have to make some rule to set this value, like planning poker.
* User Point
  * float or int type
  * default is 0
  * this is auto-calculated value by this plugin.

Finally, you have to set those Custom Fields in the Plugin's configuration.

## User point expression

* You can set the expression to calculate points for each user when the issue is closing.
* The default expression is `issue_point * 1000 * (time_entry.hours / issue.total_spent_hours)`
  This means that user will get share of issue's point by ratio of time log.
* Issue Point is distributed to each user each time the issue is closing.
* If issue is re-opening, a User Point is recalled.

# Screens

[user point detail in issue detail screen]
![User Point on Issue Detail](./docs/redmine-incentive-plugin-issue.png)
