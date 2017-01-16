# Docker integration
This package is an example on how to integrate your existing project, and put it in a docker container.

This example has an dev environment, an an ci environment.


## Installation
First, please follow the installation instructions of [Dinghy](https://github.com/codekitchen/dinghy)

If [Dinghy](https://github.com/codekitchen/dinghy) is correctly installed, that's basically the installation :-)

## GitLab Installation (optional)
This repositories offers an ```.gitlab-ci.yml.example``` file which hash some defaults in it. Rename it to ```.gitlab-ci.yml``` to enable gitlab integration. Within this file 4 environments exist (```test```, ```build```, ```deploy_to_staging```, ```deploy_to_producation```). In this file (basically) the same commands are used to run your containers, see usage.


## Usage
This package uses an 'develop' command, introduced by [Chris Fidao](http://shippingdocker.com). The ```develop``` file is an bash file which contains various commands that you can use to run the docker containers (environment independently).

### ```./develop up```
Will spin up the containers, and mount your directories using NFS.


### ```./develop down```
Will shutdown the running containers

### ```./develop ARGS```
Will run the command you give (ARGS) it using ```docker-compose```.

### ```./develop artisan ARGS```
Will run an ```php artisan``` command with the arguments you give it in an seperate container.


### ```./develop composer ARGS```
Will run an ```composer``` command with the arguments you give it in an seperate container.

### ```./develop test ARGS```
Will run an ```./vendor/bin/phpunit``` command with the arguments you give it in an seperate container to run your tests.


### ```./develop yarn ARGS```
Will run an ```yarn``` command with the arguments you give it in an seperate container.

### ```./develop gulp ARGS```
Will run an ```gulp ``` command with the arguments you give it in an seperate container.


### ```./develop```
Will run an ```docker ps``` command
