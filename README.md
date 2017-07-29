@TODO : Improve documentation // Check if devilbox is installed

@TODO : Mettre en place les process front. Les tâches d'install sont à placer dans le composer build.

@TODO : Mettre en place les scripts d'initialisation D7 / D8 / WP

@TODO : Update main [wiki](https://bitbucket.org/buzzaka/project-skeleton/wiki/Home) 


## Requirements

| Prerequisite    | How to check | How to install
| --------------- | ------------ | ------------- |
| docker >= 1.12  | `docker -v`    | [docker.com](https://www.docker.com/community-edition) |
| devilbox / Forked by Code >= 0.11  | `git branch`    | [devilbox](https://bitbucket.org/buzzaka/devilbox) |

## Install requirements (devil box)

Choose a directory (if you are a Fabernovel Team member go to `~/Webserver`)
```shell
$ git clone git@bitbucket.org:buzzaka/devilbox.git
$ cd devilbox
$ ./install.sh 
```

More details see https://bitbucket.org/buzzaka/devilbox/overview#%20usage-as-a-common-stack


## Regular install by Dev

Go to `~/Webserver/www-docker`
``` shell
$ git clone git@bitbucket.org:buzzaka/cnp-caploc.git
$ cd cnp-caploc
$ ./devilbox code install
```

### Regular scripts

#### From computer

``` shell
$ ./devilbox args # available args : config up stop cleanup exec code ssh
```


``` shell
$ ./code args # available args : install build 
```


#### Details

``` shell
$ ./devilbox config # Show local config
$ ./devilbox up # Start required docker container as daemon ( @see project-configuration DOCKER_STACK)
$ ./devilbox stop # Stop required container
$ ./devilbox cleanup # When changing some variable in .env you must re-create the container.Simply remove it, it will be auto-created during the next start:
$ ./devilbox ssh #connect to php container in www-docker path 
$ ./devilbox exec # run a command into container fwithout connect from ssh. Example : ./devilbox exec composer -v
$ ./devilbox code # is wrapper to execute ./code args cmd from local path without to connect into container
$ ./devilbox code install # run ./code install ino container 
$ ./devilbox shortlist # show available commands
``


## Regular install by Lead Dev

* You have installed devilbox
* Uri http://localhost show you something like that :
![Devilbox](docs/img/devilbox-dash-01.png)



### FOLDER ARCHITECTURE ###

see [wiki](https://bitbucket.org/buzzaka/project-skeleton/wiki/Home) 

### REQUIREMENT ###
Package needed
* SF
composer installed globally
* Drupal 7
* Drupal 8
* WordPress

### SYMFONY ###

# What the script does
* Install Symfony core
* Install usefull bundles
* Prompt for suggested bundles
* Donwload and install globally PHPUnit
* Run unit tests (defined in /app/tests/)

# Usage

## First install by Lead Dev
* Make a fork from skeleton repo to your project repo via Bitbucket, the fork name must be the project name
* Clone git project on your environment
* Create an empty database
* Create a specific user with write rights only on this database
* Configure project (edit project-configuration)

```
#!sh
$ vi ./project-configuration
```
Or 
```
#!sh
$ subl ./project-configuration
```

Edit ./project-configuration as follow : 
```shell
# Set the type of application.
# This serves as a wrapper to search for commands in the bin/ folder
# available values : drupal8,drupal7,symfony,wordpress

APP_TYPE="symfony";

# Docker stack
# Configure versions in ./.env file
# available values : see .env.example For exeample you can choose between mariadb-10.2 or mysql-5.5
# available values : httpd,nginx,mysql,redis,pgsql,memcd,mongo, ...
DOCKER_STACK="httpd php mysql redis"

# Slack notifications
PROJECT="CNP" # Prject name
CHANNEL="cnp" # Channel name
SLACK_HOOK="https://hooks.slack.com/services/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" # Webhook, normally you d'ont need ti change it

# Prod url (use for media proxy) and as default value for build scripts :
# example : https://fabernovel.com
PROD_URL=""
```

* Run an install initialisation script

```
#!sh

./devilbox code install

```

* Merge the commands from /bin/symfony/composer-commands-sample.json to your /app/composer.json (specially 'build' command and depandencies)
* Run build script

```
#!sh

./devilbox code build (args)
```


## Regular install by dev
* Create an empty database
* Create a specific user with write rights only on this database
* Run build script

```
#!sh
./devilbox code build dev
```

## Proxy distant files from your local machine
A PHP script is available for you to display the distant version of a file if it is absent form your local filesystem.
This script is agnostic about the CMS or framework you use.
As of 2017-05-01, in order to make it work, you have to:
1. Add a file-proxy.php symbolic link to /hooks/file-proxy/index.php inside the directory where your .htaccess file is located
2. Add the following lines to your .htaccess file, before any other redirection:
```
RewriteCond %{REQUEST_FILENAME} !-f
RewriteRule ([^.]+\.(jpe?g|png|gif))$ file-proxy.php?url=http://www.my-distant-url-from-where-i-want-to-retrieve-the-file.com/$1  [R=301,L,NC]
```
3. Install the script dependencies using `composer install` from the /hooks/file-proxy/ directory.

The PHP script can redirect any kind of request (not only images as suggested by the example), so pay attention to the extensions you specifiy in the RewriteRule.
Do not forget to remove the two .htaccess lines before committing your code to the production environment!

TODO:

* Make the distant host (http://www.my-distant-url-from-where-i-want-to-retrieve-the-file.com/ in the example) configurable without editing an application file (currently the .htaccess). For example, using an environment variable.
* Take into account the current environment (local, staging, production…) in order to automatically disallow the proxy behavior on sensible environments like the production one.
* Download the distant file on the local filesystem for offline usages and bandwidth saving 
