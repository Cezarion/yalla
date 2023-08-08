[TOC]

## 1.	Install dependencies

### 1.1 Docker & Docker Compose

Go to [https://docs.docker.com/docker-for-mac/install/](https://docs.docker.com/docker-for-mac/install/) and follow instructions.

After the installation open your terminal ([iTerm](https://www.iterm2.com/) is a great choice) and run

```shell
$ docker -v
$ Docker version 17.09.1-ce, build 19e2cf6
```

```shell
$ docker-compose -v
$ docker-compose version 1.17.1, build 6d101fb
```

### 1.2 Devilbox

We have created a fork of [Devilbox](https://github.com/cytopia/devilbox), see : [https://bitbucket.org/buzzaka/devilbox](https://bitbucket.org/buzzaka/devilbox)

We want to create the following tree:

```
.
├── devilbox    # This folder will contain all the application docker / devilbox
└── www-docker  # This folder will contain all our applications / sites
```

So choose a folder or create in one, or if folder exist goto `~/Webserver`

#### Clone Devilbox

Open your terminal:

```shell
$ git clone git@bitbucket.org:buzzaka/devilbox.git -b skeleton-stack && cd devilbox
```

#### Install Devilbox

```
$ ./install.sh
```

This script :
- create a www-docker folder next to the current folder
- create a .devilbox file in the www-docker folder
- run `./update-docker.sh` : pull all Docker images that are currently bound to your devilbox git state.

```shell
# Init local stack from current directory
$ cat ~/.devilbox
# This file is generated automatically, does not edit or does not restart the install.sh script in Devilbox
HOST_PATH_HTTPD_DATADIR=/Users/me/Webserver/devilbox/../www-docker
DEVILBOX_LOCAL_PATH=/Users/me/Webserver/devilbox
```

## 2.	Install Yalla

Yalla is:
- a cli interface
- a set of tools orchestrated by the cli interface

### 2.1 Install yalla cli

```shell
$ curl -s https://yalla-stable.fabernovel.co/src/cli/cli-install | sh
$ yalla -v
Local cli version  0.1.7
Remote cli Version 0.1.7
$ yalla -h # for a detailed help
```
