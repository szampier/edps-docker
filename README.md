# ESO Data Processing System in Docker
This repository is used to store the Dockerfile and other configuration files which can be used to create a Docker image for the [ESO Data Processing System](https://www.eso.org/sci/software/edps.html).

## Installation

1. Install docker or podman on your system if not already available

1. Create docker image for a specific [VLT Instrument Pipeline](https://www.eso.org/sci/software/pipelines/)

`docker build --no-cache --build-arg PIPEID=<pipeline> -t edps .`

Supported pipelines:

* ESPRESSO: `PIPEID=espdr`
* UVES: `PIPEID=uves`
* KMOS: `PIPEID=kmos`


3. Run container and start `edps-server`

`docker run --rm --user=$(id -u):$(id -g) --name edps -v /tmp:/data edps edps-server`

4. Execute edps command to reduce your data

```
alias edps='docker exec edps edps'`
edps --help
edps -lw
...
```
