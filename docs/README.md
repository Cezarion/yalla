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

Main commands:
------------

### A tester
yalla start : start containers (= yalla dr start) + show local uri    
yalla restart : restart containers (= yalla dr restart)  + show local uri
yalla stop : stop containers (= yalla dr stop)
yalla init =  yalla create-project + edit .env
              yalla app setup-settings if cat .gitignore | grep yalla = ''
              + edit /etc/hosts
yalla connect = yalla dr connect => enter into container into current project


yalla install =  clone yalla + yalla start + create database + import database  + edit /etc/hosts + show local uri
yalla info = yalla dr status = show running container, database params, project uri, remote infos (db,uri)



## @ Todo

* Setting up the readme template and copy to project
* During app setup-config : copy .env sample
* During process specify that database infos are for local env
* When config exist, add command | readme to create db
* Notify if local apache or mysql is running
* Setup /etc/hosts
* How to start with an existing yalla project
  -> @missing clone yalla   
  -> @missing create user and database   
  -> @missing import db   
  -> @missing instructions    
  -> @missing setup project with db info   

* Setup script for symfony,d8,angular,themosis


## @ Failed
* Error during mysql import / run container

## @ Test

* Pull database from target (staging|preprod|prod)
* Cmd yalla dr restart = yalla dr stop && yalla dr cleanup && yalla dr up   => Do comannd  

## @ Sources articles :
https://medium.com/@pimterry/testing-your-shell-scripts-with-bats-abfca9bdc5b9
https://github.com/shellfire-dev/shellfire
http://www.bashoneliners.com/
http://www.bpkg.sh/pkg/
https://github.com/ash-shell/yaml-parse
http://www.bpkg.sh/pkg/bashsh
https://github.com/johnlane/random-toolbox/blob/master/usr/lib/yay
