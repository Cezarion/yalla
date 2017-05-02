#!/bin/bash


# Set the type of application.
# This serves as a wrapper to search for commands in the bin/ folder
# available values : drupal8,drupal7,symfony,wordpress

APP_TYPE="symfony";

export APP_TYPE;

# Slack notifications
export PROJECT="project name"
export CHANNEL="slack channel"
export SLACK_HOOK="https://hooks.slack.com/services/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"

# Prod url (use for media proxy) and as default value for build scripts :

export PROD_URL="" # https://fabernovel.com