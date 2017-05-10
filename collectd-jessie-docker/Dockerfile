# VERSION 1.0
# AUTHOR: Donn Lee
# DESCRIPTION: Debian jessie collectd image. Based largely on github.com:puckel/docker-collectd.git
# BUILD: docker build --rm -t donn/collectd-jessie-docker
# SOURCE: https://github.com/donnlee/collectd-docker

# Use backports for latest collectd version.
FROM debian:jessie-backports
MAINTAINER donn

# Never prompts the user for choices on installation/configuration of packages
ENV DEBIAN_FRONTEND noninteractive
ENV TERM linux
# Work around initramfs-tools running on kernel 'upgrade': <http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=594189>
ENV INITRD No

# Add non-free repo for snmp-mibs-downloader.
#RUN cat /etc/apt/sources.list | sed -ne 's/jessie main/jessie main non-free/;p' > /tmp/sources.list \
#    && mv /tmp/sources.list /etc/apt/

RUN apt-get update -y \
    && apt-get install -y \
    curl less wget unzip vim man \
    python-pip \
    && pip install envtpl \
    && apt-get clean

# Current dir is "/" at this point. And we are root.
# 2017/05/09: jessie-backports repo provides collectd v5.7
RUN apt-get install -y -t jessie-backports collectd
RUN mv /etc/collectd/collectd.conf /etc/collectd/collectd.conf.orig_from_pkg \
    && mkdir -p /usr/share/collectd/ \
    && wget -O /usr/share/collectd/types.db https://raw.githubusercontent.com/collectd/collectd/master/src/types.db

#RUN apt-get install -y snmp snmp-mibs-downloader

# In prod, cleanup files.
#RUN rm -rf \
    # /var/lib/apt/lists/* \
    # /tmp/* \
    # /var/tmp/* \
    # /usr/share/man \
    # /usr/share/doc \
    # /usr/share/doc-base

ADD collectd.conf.tpl /etc/collectd/collectd.conf.tpl
ADD write_graphite.conf.tpl /etc/collectd/collectd.conf.d/write_graphite.conf.tpl
ADD write_influxdb.conf.tpl /etc/collectd/collectd.conf.d/write_influxdb.conf.tpl
ADD run.sh /root/run.sh
RUN chmod +x /root/run.sh

#CMD ["/root/run.sh"]
CMD ["tail", "-f", "/dev/null"]
# Not needed. Collectd is sending to influxdb via 'network' plugin.
#EXPOSE 25826/udp

