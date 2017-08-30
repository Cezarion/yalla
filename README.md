# Fabernovel Code // Yalla Boilerplate
--------------


This project allows to quickly and easily mount a boilerplate for Fabernovel Code projects.

It consists of a command cli which allows to have a unique command through the projects but also to generate a new project.
It also consists of a set of scripts to launch commands within the project.

Coupling with [devilbox](https://bitbucket.org/buzzaka/devilbox), a docker stack, it will allow the rapid establishment of a development environment.

** What's new / changing **

Before the skeleton was an integral part of the project and was versioned with the project.
As a result, it was difficult to update the skeleton.

Now the skelleton becomes a dependency of the project, the whole of this application is grouped in a folder yalla, itself under git.
So it will be possible to make a correction or an update and make a pull request on the skeleton.

_The new architecture :_

project/
    application/
    logs/
    shared/
    tests
    yalla/

--------------

### Supported operating systems 

![Linux](https://raw.githubusercontent.com/cytopia/icons/master/64x64/linux.png) ![OSX](https://raw.githubusercontent.com/cytopia/icons/master/64x64/osx.png)

--------------

## Requirements

| Prerequisite    | How to check | How to install |
| --------------- | ------------ | ------------- |
| git >= 2  | `git --version`    | [git-scm.com](https://git-scm.com/book/fr/v1/D%C3%A9marrage-rapide-Installation-de-Git) |
| docker >= 1.12  | `docker -v`    | [docker.com](https://www.docker.com/community-edition) |
| devilbox / Forked by Code >= 0.11  | `git branch`    | [devilbox](https://bitbucket.org/buzzaka/devilbox) |
| Yalla cli  | `which yalla`    | [yalla-cli](#markdown-header-install-yalla-cli) |


## Install yalla-cli

```shell
curl -s https://buzzaka:Buzz06\$dev@yalla-dl.fabernovel.co/cli-install | sh
```

That's all. 

## Install Devil Box

Choose a directory (if you are a Fabernovel Team member go to `~/Webserver`)
```shell
$ $user@machine:~/Webserver| git clone -b skeleton-stack --single-branch git@bitbucket.org:buzzaka/devilbox.git devilbox 
$ $user@machine:~/Webserver| cd devilbox
$ $user@machine:~/Webserver| ./install.sh 
```

More details see https://bitbucket.org/buzzaka/devilbox/overview#%20usage-as-a-common-stack

This will create a `devilbox` folder that is going to be the heart of the stack lamp, ...
This stack contains enough to launch containers redis, apache, mysql, ...

This will also create a `www-docker` folder at the same level as devilbox.
It is here that the projects will be initiated.

```shell
$ $user@machine:~/Webserver/devilbox| cd ..
$ $user@machine:~/Webserver| ls 
$ $user@machine:~/Webserver| devilbox www-docker
```


## Init a new project 

Go to `~/Webserver/www-docker`
```shell
$ $user@machine:~/Webserver| cd www-docker
$ $user@machine:~/Webserver| mkdir new-project && cd $_ 
$ $user@machine:~/Webserver/new-project| yalla create-project
```


# ------ DEPRECATED - LINE BELOW NEEDS TO BE UPDATED ------- 
### Regular scripts

#### From computer

``` shell
$ ./devilbox args # available args : config up stop cleanup exec code ssh
```


``` shell
$ .code args # available args : install build 
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
```


## Regular install by Lead Dev

* You have installed devilbox
* Uri http://localhost show you something like that :
![Devilbox](docs/img/devilbox-dash-01.png)

### Configure app

Start edit project-configuration

```shell
#!sh
$ vi ./project-configuration
```
Or 
```shell
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
```shell
#!sh
./code build dev
```

* That's it.
