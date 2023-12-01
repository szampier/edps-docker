FROM fedora:37
MAINTAINER Stefano Zampieri szampier@eso.org

ARG pipeline

ENV XDG_RUNTIME_DIR=/.edps

RUN dnf install -y dnf-plugins-core && \
  dnf update -y && \
  dnf config-manager -y --add-repo=https://ftp.eso.org/pub/dfs/pipelines/repositories/stable/fedora/esorepo.repo && \
  dnf clean all

# skip networkx extra-dependencies to reduce image size (PIPE-10752)
RUN dnf install -y --setopt=install_weak_deps=False python3-networkx

# install ESO pipeline (incl. EDPS workflow and ADARI reports)
RUN for pipe in $(echo ${pipeline} | tr "," "\n"); \
    do dnf install -y esopipe-${pipe}-wkf esopipe-${pipe}-datastatic; done && \
    dnf install -y esopipe-detmon && dnf clean all

# create EDPS & ADARI runtime directory
RUN mkdir $XDG_RUNTIME_DIR && chmod 777 $XDG_RUNTIME_DIR
WORKDIR $XDG_RUNTIME_DIR
COPY application.properties logging.yaml ./
# RUN wget https://raw.githubusercontent.com/szampier/edps-docker/main/application.properties
# RUN wget https://raw.githubusercontent.com/szampier/edps-docker/main/logging.yaml

ENTRYPOINT ["edps-server"]
