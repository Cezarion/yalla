{{DOCKER_STACK="httpd php mysql"}}
{{SLACK_HOOK="https://hooks.slack.com/services/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"}}
# Set the type of application.
# This serves as a wrapper to search for commands in the bin/ folder
# available values : drupal8,drupal7,symfony,wordpress

APP_TYPE="{{APP_TYPE}}";

# Docker stack
# Configure versions in ./.env file
DOCKER_STACK="{{DOCKER_STACK}}"

# Slack notifications
PROJECT="CNP"
CHANNEL="cnp"
SLACK_HOOK="{{SLACK_HOOK}}"

# Prod url (use for media proxy) and as default value for build scripts :
# example : https://fabernovel.com
PROD_URL=""

# Db dev user
# Automatically create the database and user for dev environments

# User
DB_DEV_USER={{DB_DEV_USER}}
DB_DEV_PASS={{DB_DEV_PASS}}
DB_DEV_DATABASE_NAME={{DB_DEV_DATABASE_NAME}}
