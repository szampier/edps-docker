FROM fedora:34
MAINTAINER Stefano Zampieri szampier@eso.org

ARG PIPEID

ENV ADARI_SOCKET=/run/user/1111
ENV EDPS_CONFIG_DIR=/.edps/

RUN dnf install -y dnf-plugins-core && \
  dnf update -y && \
  dnf config-manager -y --add-repo=https://ftp.eso.org/pub/dfs/pipelines/repositories/stable/fedora/esorepo.repo && \
  dnf clean all

# skip networkx extra-dependencies to reduce image size (PIPE-10752)
RUN dnf install -y --setopt=install_weak_deps=False python3-networkx
# ESO pipeline (incl. all dependencies like ADARI, EDPS, Python3, ...)
# RUN dnf install -y esopipe-${PIPEID}-wkf-${PIPEVER} esopipe-${PIPEID}-datastatic-${PIPEVER} esopipe-detmon && \
RUN dnf install -y esopipe-${PIPEID}-wkf esopipe-${PIPEID}-datastatic esopipe-detmon && \
  dnf clean all

RUN pip install --extra-index-url https://ftp.eso.org/pub/dfs/pipelines/libraries edps adari_core

# force astropy to download up-to-date leap seconds (DFS-19755)
RUN python -c "from astropy.coordinates import SkyCoord"

RUN mkdir $EDPS_CONFIG_DIR
COPY ./application.properties $EDPS_CONFIG_DIR
COPY ./logging.yaml $EDPS_CONFIG_DIR
RUN chmod 777 $EDPS_CONFIG_DIR

WORKDIR $EDPS_CONFIG_DIR
