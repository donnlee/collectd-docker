# VERSION 1.0
# AUTHOR: Donn Lee
# DESCRIPTION: Basic collectd image. Based largely on github.com:puckel/docker-collectd.git
# BUILD: docker build --rm -t donn/collectd
# SOURCE: https://github.com/donnlee/collectd-docker

FROM ubuntu:trusty
MAINTAINER donn

# Never prompts the user for choices on installation/configuration of packages
ENV DEBIAN_FRONTEND noninteractive
ENV TERM linux
# Work around initramfs-tools running on kernel 'upgrade': <http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=594189>
ENV INITRD No

RUN apt-get update -yqq \
    && apt-get install -yqq \
    curl wget unzip vim man \
    python-pip \
    && pip install envtpl \
    && apt-get clean \
    # Current dir is "/" at this point. And we are root.
    && wget https://collectd.org/files/collectd-5.5.0.tar.gz \
    && tar zxvf collectd-5.5.0.tar.gz \
    && cd collectd* \
    && ./configure \
    && make all install \
    && cd .. \
    && rm -rf collectd-5.5.0/ \
    && rm -f collectd-5.5.0.tar.gz
    && sudo wget -O /etc/init.d/collectd https://raw.githubusercontent.com/martin-magakian/collectd-script/master/collectd.init \
    && sudo chmod 744 /etc/init.d/collectd \
    && ln -s /opt/collectd/sbin/collectd /usr/sbin/collectd \
    && ln -s /opt/collectd/sbin/collectdmon /usr/sbin/collectdmon \
    && mkdir -p /usr/share/collectd/ \
    && wget -O /usr/share/collectd/types.db https://raw.githubusercontent.com/collectd/collectd/master/src/types.db \
    && mv /opt/collectd/etc/collectd.conf /opt/collectd/etc/collectd.conf.orig_from_build \
    && ln -s /etc/collectd/collectd.conf /opt/collectd/etc/collectd.conf \
    && ln -s /opt/collectd/lib/collectd /usr/lib/collectd \
    && rm -rf \
    /var/lib/apt/lists/* \
    /tmp/* \
    /var/tmp/* \
    /usr/share/man \
    /usr/share/doc \
    /usr/share/doc-base

ADD config/collectd.conf.tpl /etc/collectd/collectd.conf.tpl
ADD config/write_graphite.conf.tpl /etc/collectd/collectd.conf.d/write_graphite.conf.tpl
ADD config/write_influxdb.conf.tpl /etc/collectd/collectd.conf.d/write_influxdb.conf.tpl
ADD scripts/run.sh /root/run.sh
RUN chmod +x /root/run.sh

CMD ["/root/run.sh"]
# Not needed. Collectd is sending to influxdb via 'network' plugin.
#EXPOSE 25826/udp

