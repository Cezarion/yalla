
> Make sure you have all the dependencies installed
> See [Installing dependencies](./installing-dependencies.md)

**Yalla is:**
- a cli interface
- a set of tools orchestrated by the cli interface


## 1 Install yalla cli

```shell
$ curl -s https://yalla-stable.fabernovel.co/src/cli/cli-install | sh
$ yalla -v
Local cli version  0.1.7
Remote cli Version 0.1.7
$ yalla -h # for a detailed help
```

## 2.	Init a new Yalla project

<br/>
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
$ $user@machine:www-docker/new-project: mkdir new-project && cd $_
$ $user@machine:www-docker/new-project: yalla init
```
