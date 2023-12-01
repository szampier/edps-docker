# Dockerfile for the ESO Data Processing System (EDPS)
This repository holds the `Dockerfile` and other configuration files which can be used to create a Docker image for the [ESO Data Processing System](https://www.eso.org/sci/software/edps.html).

## Installation

1. Clone this repo or download ZIP

`git clone https://github.com/szampier/edps-docker.git && cd edps-docker`

`wget https://github.com/szampier/edps-docker/archive/refs/heads/main.zip && unzip main.zip && cd edps-docker-main`

2. Install [docker](https://docs.docker.com/engine/install/#server) or [podman](https://podman.io/) on your system if not already available.
Please note that [Docker Desktop](https://www.docker.com/products/docker-desktop/) is not required for this installation.

3. Create docker image for one or more of the supported [VLT Instrument Pipelines](https://www.eso.org/sci/software/pipelines/)

`docker build --no-cache --build-arg pipeline=<comma-separated-list-of-instrument-pipelines> -t edps .`

EDPS currently supports the following instrument pipelines: `espdr` (ESPRESSO), `uves` and `kmos`

NOTE: `-t, --tag` is used to tag the container image created with `docker build`. If you change the default name (`edps`)
please use the new name also in the `docker run` command.

4. Run edps docker container

`docker run --rm --user=$(id -u):$(id -g) --name edps -v <data-dir>:/data -d edps`

5. Execute edps command (alias) to reduce your data

```
alias edps='docker exec edps edps'
edps --help
edps -lw
...
```

See [EDPS Tutorial](https://ftp.eso.org/pub/dfs/pipelines/libraries/edps/edps_tutorial0.9.pdf) for detailed instructions on how to use EDPS.

6. Shutdown edps and delete docker container

`docker stop edps`

or

`edps -shutdown`
