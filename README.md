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