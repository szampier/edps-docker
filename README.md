# Dockerfile for the ESO Data Processing System (EDPS)
This repository holds the `Dockerfile` and other configuration files which can be used to create a Docker image for the [ESO Data Processing System](https://www.eso.org/sci/software/edps.html).

## Installation

1. Install docker or podman on your system if not already available

1. Create docker image for one of the supported [VLT Instrument Pipelines](https://www.eso.org/sci/software/pipelines/)

`docker build --no-cache --build-arg PIPEID=<My Pipeline> -t edps .`

Supported pipelines:

* ESPRESSO: `PIPEID=espdr`
* UVES: `PIPEID=uves`
* KMOS: `PIPEID=kmos`


3. Run edps docker container

`docker run --rm --user=$(id -u):$(id -g) --name edps -v <My Data Dir>:/data -d edps`

4. Execute edps command to reduce your data

```
alias edps='docker exec edps edps'
edps --help
edps -lw
...
```

See [EDPS Tutorial](https://ftp.eso.org/pub/dfs/pipelines/libraries/edps/edps_tutorial0.9.pdf) for detailed instructions on how to use EDPS.

5. Shutdown edps and delete docker container

`edps -shutdown`
