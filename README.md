# Fabernovel Code // Yalla Boilerplate
--------------

> This project allows to quickly and easily mount a boilerplate for Fabernovel Code projects.
> It consists of a command cli which allows to have a unique command through the projects but also to generate a new project.
> It also consists of a set of scripts to launch commands within the project.
>
> Coupling with [devilbox](https://bitbucket.org/buzzaka/devilbox), a docker stack, it will allow the rapid establishment of a development environment.

** What's new / changing **

Before the skeleton was an integral part of the project and was versioned with the project.
As a result, it was difficult to update the skeleton.

Now the skeleton becomes a dependency of the project, the whole of this application is grouped in a folder **yalla**, itself under git.
So it will be possible to make a correction or an update and make a pull request on the skeleton.

_The new architecture :_
```
project/
    application/
    logs/
    shared/
    tests/
    yalla/
```
--------------

## Table of content

[TOC]

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


## Init from an existing project

Go to `~/Webserver/www-docker`
```shell
$ $user@machine:~/Webserver| cd www-docker
$ $user@machine:~/Webserver| git clone my-project && cd $_
$ $user@machine:~/Webserver/new-project| yalla app setup-settings
```

## Main config files

##### yalla.settings :
* Set variables for yalla, define slack channel to notify on deploy, ...

##### hosts.yml :
* Set up base config to allow ansible mysql sync

## Pull database from remote host :

* Populate `hosts.yml` with remote datas  
* Edit secrets (vault) : run  
    ```
    yalla av create
    ```
* Edit like that :   
    ```
    vault_staging_db_pass: your-staging-pass   
    vault_preprod_db_pass: your-preprod-pass    
    vault_live_db_pass:    your-db-pass
    ```    
* Run   
    ```
    yalla ap mysql-sync -e "source="staging|preprod|live"    --ask-vault-pass'
    ```


If there is a problem, open a ticket
https://bitbucket.org/buzzaka/project-skeleton/issues?status=new&status=open

## Commands

### Mysql :

```
yalla db | mysql -d database_name -f path/to/file.sql #import a database
yalla db | mysql -d database_name -i "SHOW TABLES;" #run an inline sql command script
yalla db | mysql -i "SHOW DATABASES;" #run an inline sql command script
yalla db | mysql -f ./backup/create_user_and_database.sql #import an sql file
```
NB : Only Mysql, Mariadb or Perconna server are available


### Docker :

```
# Main command yalla docker | dr
yalla docker config            Validate and view the Compose file
yalla docker stop              Stop services
yalla docker start             Start services
yalla docker build             Build or rebuild services
yalla docker cleanup           Remove stopped containers
yalla docker ssh               Connect to main docker container, where the code is and where the commands are available (wp cli, node, ...)
yalla docker connect           Connect to main docker container, directly in path to project
yalla docker exec              Execute a command in a running container
```

### Ansible Playbooks:

*@see : http://docs.ansible.com/ansible/latest/playbooks.html*

Usage: yalla ap | ansible-playbook [-vikCKbe] [-e ANSIBLE EXTRA VARS] [options]...

##### Options:
```
    -v          verbose mode. Can be used multiple times for increased verbosity.
    -h          display this help and exit
    --ask-vault-pass      ask for vault password

    -e                    set additional variables as key=value
    --flush-cache         clear the fact cache
    -C, --check           no changes; instead, try to predict some
    -k, --ask-pass        ask for connection password
    -u                    connect as this user (default=None)
```
##### Privilege Escalation Options:
```
    control how and which user you become as on target hosts

    -b, --become        run operations with become (does not imply password prompting)
    --become-method=BECOME_METHOD
                        privilege escalation method to use (default=sudo),
                        valid choices: [ sudo | su | pbrun | pfexec | doas |
                        dzdo | ksu | runas | pmrun ]
    --become-user=BECOME_USER
                        run operations as this user (default=root)
    -K, --ask-become-pass
```

##### Available Playbooks:


mysql-sync.yml : pull database from remote host


**Example :**
```
    yalla ap mysql-sync -e "source=staging"
```

##### Access all ansible-playbook variables:

If you need to run others and non available options within Ansible, run :
```
docker-compose -f yalla/docker/docker-compose.yml run --rm  ansible_playbook /ansible-playbook/[PLAYBOOK-NAME].yml [options]
```

### Ansible Vault:

@see : http://docs.ansible.com/ansible/latest/playbooks_vault.html

##### Options:

```
yalla av create      Create encrypted files
yalla av edit        Editing encrypted files
yalla av rekey       Rekeying encrypted files
yalla av view        Viewing encrypted files
yalla av decrypt     Decrypting encrypted files
yalla av encrypt     Encrypting unencrypted files
yalla av -h, --help  display this help and exit
```

**Example :**
```
    yalla av | ansible-vault create
```

#### Run ansible vault in a regular way:

If you need to run others and non available options within Ansible, run :
```
docker-compose -f yalla/docker/docker-compose.yml run --rm  ansible_vault [options]
```
