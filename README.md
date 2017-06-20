@TODO : Mettre en place les process front. Les tâches d'install sont à placer dans le composer build.

@TODO : Mettre en place les scripts d'initialisation D7 / D8 / WP

@TODO : Update main [wiki](https://bitbucket.org/buzzaka/project-skeleton/wiki/Home) 

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
* Run an install initialisation script

```
#!sh

./code install

```

* Merge the commands from /bin/symfony/composer-commands-sample.json to your /app/composer.json (specially 'build' command and depandencies)
* Run build script

```
#!sh

./code build (args)
```


## Regular install by dev
* Create an empty database
* Create a specific user with write rights only on this database
* Run build script

```
#!sh
./code build dev
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
