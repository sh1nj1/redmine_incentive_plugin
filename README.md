# Redmine Incentive Plugin

Simple incentive system with custom fields and time log.

* Add SP to Issue
* Add XP to User
* Log time on Issue
* When the Issue is closing, all contributed users get points.

# Tested redmine version

* 3.4.4, 3.2.3

# Install

To install this plugin, follow the general Redmine's Plugin installation.

# Configuration

After installing, you have to configure the plugin.

You have to add two Custom Fields.

* Issue's Story Point
  * float or int type
  * This value is given by Human. A team have to make some rule to set this value, like planning poker.
* User's XP
  * float or int type
  * default is 0
  * this is auto-calculated value by this plugin.

Finally, you have to set those Custom Fields in the Plugin's configuration.

# Rules

* Issue's SP is distributed to each user each time the issue is closing.
* If issue is re-opening, a user's XP is recalled.
* The distribution ratio is as same as user's contribution ratio on that issue by time log.
