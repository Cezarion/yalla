
> Make sure you have all the dependencies installed
> See [Installing dependencies](./installing-dependencies.md)



**Yalla is:**
* a cli interface
* a set of tools orchestrated by the cli interface


## 1 Install yalla cli

```shell
$ curl -s https://yalla-stable.fabernovel.co/src/cli/cli-install | sh
$ yalla -v
Local cli version  0.1.7
Remote cli Version 0.1.7
$ yalla -h # for a detailed help
```

## 2.	Init a new Yalla project


**1. Load Devilbox params : **
```
$ . ~/.devilbox
```

**2. Go to www-docker : **
```
$ cd $HOST_PATH_HTTPD_DATADIR
$ $user@machine:www-docker:
```

**3. Init new project : **

```
$ $user@machine:www-docker: mkdir new-project && cd $_
$ $user@machine:www-docker/new-project: yalla init
```

#### `yalla init` does the following actions :

* Clone latest version of `yalla` into a `yalla` dir
* Create directories and add .gitkeep in this directories as follow :
  ```
  new-project/
    application/
    logs/
    shared/
    tests/
    vaults/
    yalla/
  ```
* Create required and sample files (.editorconfig, README, ... )



#### `yalla init` will ask you a few things:

1. Edit .env file
  * This file contain all available docker image version per services (php 5.6, php 7.1, ... mysql or mariadb, ...)
  * Edit this file with the desired version. Leave the non-useful services as is.

2. Project parameters :
  * Name : for title in Slack notification
  * Slack channel : to send notification to slack channel

3. Application type :
  * Necessary to generate desired .gitignore from [gitignore.io](https://www.gitignore.io/)
  * Later to load dedicated project template / starter

4. Required docker stack :
  * All the services you need for your project

5. If a production environment exist
  * Necessary to prepare

6. Desired local database parameters
  * This will be shared with all other developers working on the project.

7. Next steps, Yalla will ask you to setup remote existing environment (staging, preprod, live)
  * As we will see later, yalla use [ansible](https://www.ansible.com/) to synchronise database trough environment. These settings will allow you to do this.
  * Fill only desired/known environments
  * The following informations will be requested :
  ```
      Server Ip / hostname:
      Ssh user:
      Project path on server:

      Database name:
      Database user name:
      Site url:
  ```

8. Yalla generated the following files
  * Create base .gitignore with this params : linux,osx,windows,PhpStorm,SublimeText,VisualStudio
  * Create base application/.gitignore from Application type (step 3)

9. Now, it will ask you if you want to generate local user and database
  * You can create them now or manually do it later.
  * if yes : it will start database containers and run actions.

10. Now, it will ask you if you want to import an existing mysql dump
  * if yes : copy desired sql file into the `backup/` project path

##### Bravo ! it's finished
It may be a bit long, but you have laid the foundations of the project and especially its sharing with the rest of the devs.

### 4. Commit configuration

#### 4.1 It's a new project :

##### Commit and share your setup
```
$ $user@machine:www-docker/new-project: git init
$ $user@machine:www-docker/new-project: git remote add origin git@bitbucket.org:buzzaka/new-project.git
$ $user@machine:www-docker/new-project: git add .
$ $user@machine:www-docker/new-project: git commit -am 'Init project with yalla settings'
$ $user@machine:www-docker/new-project: git push origin master
```

##### Start to configure and setup your project :

Devilbox and the php docker container arrives with many known php project cli tools preinstalled.
So, it's not necessary to install this tools on your host.

See bellow :

```
# Go to docker container into project path
$ $user@machine:www-docker/new-project: yalla connect
$ devilbox@php-7.2.0 in /shared/httpd/new-project: composer create-project symfony/skeleton application
$ devilbox@php-7.2.0 in /shared/httpd/new-project: exit
# Create apache docroot :
$ $user@machine:www-docker/new-project: ln -s application/web htdocs
```

#### 4.2 It's an existing project :

For example Mgen Mmmieux (git@bitbucket.org:buzzaka/mgen-mmmieux.git)

Yalla create some defaults directory. If it's not necessary for your project delete it.       
For example in mgen-mmmieux, this directory is not necessary `application`.  
Just do an `rm -r application`


> TODO
> Show how to setup vault and run database sync
```
# Go to docker container into project path
$ $user@machine:www-docker/mgen-mmmieux: ln -s app/
$ $user@machine:www-docker/mgen-mmmieux: yalla connect
$ devilbox@php-7.2.0 in /shared/httpd/mgen-mmmieux: ./code install dev fabernovel
$ devilbox@php-7.2.0 in /shared/httpd/new-project: exit
# Create apache docroot :
$ $user@machine:www-docker/new-project: ln -s application/web htdocs
```

## 3.	Install a Yalla project

> TODO
> Show how to setup vault and run database sync


##### `yalla install` will ask you a few things:

1. Create local user and database
  * If mysql params are set, it will work, else it failed
2. Import an existing dump :
  * if yes : copy desired sql file into the `backup/` project path
  * answer with path/to-file.sql from project
3. That's all
  * Now connect to project into devilbox and run project scripts install
