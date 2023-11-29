FROM fedora:34
MAINTAINER Stefano Zampieri szampier@eso.org

ARG PIPEID

ENV ADARI_SOCKET=/run/user/1111
ENV EDPS_CONFIG_DIR=/.edps

RUN dnf install -y dnf-plugins-core && \
  dnf update -y && \
  dnf config-manager -y --add-repo=https://ftp.eso.org/pub/dfs/pipelines/repositories/stable/fedora/esorepo.repo && \
  dnf clean all

# skip networkx extra-dependencies to reduce image size (PIPE-10752)
RUN dnf install -y --setopt=install_weak_deps=False python3-networkx

# install ESO pipeline (incl. EDPS workflow and ADARI reports)
RUN dnf install -y esopipe-${PIPEID}-wkf esopipe-${PIPEID}-datastatic esopipe-detmon && \
  dnf clean all

# install EDPS and ADARI
RUN pip install --extra-index-url https://ftp.eso.org/pub/dfs/pipelines/libraries edps adari_core

# force astropy to download up-to-date leap seconds (DFS-19755)
RUN python -c "from astropy.coordinates import SkyCoord"

# create EDPS working directory and install config files
RUN mkdir $EDPS_CONFIG_DIR && chmod 777 $EDPS_CONFIG_DIR
WORKDIR $EDPS_CONFIG_DIR
COPY application.properties logging.yaml ./
# RUN wget https://raw.githubusercontent.com/szampier/edps-docker/main/application.properties
# RUN wget https://raw.githubusercontent.com/szampier/edps-docker/main/logging.yaml

