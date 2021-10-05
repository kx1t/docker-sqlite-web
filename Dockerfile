FROM debian:buster-20210927-slim

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN set -x && \
# define packages needed for installation and general management of the container:
    TEMP_PACKAGES=() && \
    KEPT_PACKAGES=() && \
    KEPT_PIP_PACKAGES=() && \
    KEPT_RUBY_PACKAGES=() && \
    # Required for building multiple packages.
    TEMP_PACKAGES+=(pkg-config) && \
    TEMP_PACKAGES+=(gnupg2) && \
    TEMP_PACKAGES+=(file) && \
    KEPT_PACKAGES+=(curl) && \
    KEPT_PACKAGES+=(ca-certificates) && \
    KEPT_PACKAGES=+(python3)
    KEPT_PACKAGES+=(psmisc) && \
    KEPT_PACKAGES+=(procps nano) && \
    KEPT_PACKAGES+=(python-pip) && \
    KEPT_PACKAGES+=(python-setuptools) && \
    KEPT_PIP_PACKAGES+=(sqlite-web) && \
    echo ${TEMP_PACKAGES[*]} > /tmp/vars.tmp && \
#
# Install all the KEPT packages (+ pkgconfig):
    apt-get update && \
    apt-get install -o APT::Autoremove::RecommendsImportant=0 -o APT::Autoremove::SuggestsImportant=0 -o Dpkg::Options::="--force-confold" -y --no-install-recommends  --no-install-suggests\
        {TEMP_PACKAGES[@}]} {KEPT_PACKAGES[@]} && \
    update-alternatives --install /usr/bin/python python /usr/bin/python3 1 && \
    pip install ${KEPT_PIP_PACKAGES[@]}

EXPOSE 8080
VOLUME /data
WORKDIR /data
CMD sqlite_web -H 0.0.0.0 -x $SQLITE_DATABASE -u $URL_PREFIX $EXTRA_ARGS
