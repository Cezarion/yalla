# Necessaries commands

yalla install-dev-stack -> clone devil box, run devil box install script

yalla create-project => ? project init -> init a new project skeleton

yalla project init (symfony,drupal7,drupal8,wp)
              install
              build dev | prod
              sync-db src_env to dest_env


yalla docker config
             up
             build
             stop
             cleanup
             ssh
             exec
             ? code
             mysql


Really necessary ?
------------
yalla composer [cmd]   
yalla npm [cmd]    
yalla gulp [cmd]   
yalla ng-cli [cmd]    
yalla drush [cmd]   
yalla drupal-console [cmd]      


## @Todo

* Setting up the readme template and copy to project
* During app setup-config : copy .env sample
* During process specify that database infos are for local env
* When config exist, add command | readme to create db
* Notify if local apache or mysql is running
* How to start with an existing yalla project
  -> @missing clone yalla
  -> @missing create user and database
  -> @missing import db
  -> @missing instructions
  -> @missing setup project with db info
* Cmd yalla dr restart = yalla dr stop && yalla dr cleanup && yalla dr up

## @Check

* Error during mysql import / run container

## @test

* Pull database from target (staging|preprod|prod)
* Setup script for symfony,d8,angular,themosis
