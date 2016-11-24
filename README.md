### REQUIREMENT ###
Package needed
    SF
        composer installed globally
    Drupal 7
    Drupal 8
    WordPress

### SYMFONY ###

# What the script do
    Install Symfony core
    Install usefull bundles
    Prompt for suggested bundles
    Donwload and install globally PHPUnit
    Run unit tests (defined in /app/tests/)

# Usage

    ## First install by Lead Dev
        Make a fork from skeleton repo to your project repo via Bitbucket
        Create an empty database
        Create a specific user with write rights only on this database
        Run an install initialisation script
            sh bin/symfony/init.sh
        Merge the commands from /bin/symfony/composer-commands-sample.json to your /app/composer.json (specially 'build' command)

    ## Regular install by common dev
        Create an empty database
        Create a specific user with write rights only on this database
        Run build script
            sh bin/symfony/build.sh

