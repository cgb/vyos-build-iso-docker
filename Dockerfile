FROM debian:squeeze

ENV DEBIAN_FRONTEND noninteractive

ADD sources.list /etc/apt/sources.list
RUN echo 'Acquire::Check-Valid-Until "false";' >/etc/apt/apt.conf.d/90ignore-release-date && apt-get update \
    && apt-get install -y wget \
    && wget -O - http://packages.vyos.net/vyos-release.gpg | apt-key add - \
    && echo "deb http://archive.debian.org/debian-backports/ squeeze-backports main" > /etc/apt/sources.list.d/bp.list \
    && apt-get update \
    && apt-get -t squeeze-backports install -y squashfs-tools \
    && echo "" >/etc/apt/sources.list.d/bp.list \
    && apt-get update \
    && apt-get install -y autoconf dpkg-dev syslinux make lsb-release fakechroot devscripts \
                          git automake live-helper genisoimage \
    && apt-get install -y kernel-package \
    && apt-get clean

RUN mkdir -p /data; cd /data; git clone https://github.com/vyos/build-iso.git
RUN mkdir -p /data/bin
ADD bin/vyos-build-iso /data/bin/vyos-build-iso

WORKDIR /data
ENTRYPOINT ["/data/bin/vyos-build-iso"]
