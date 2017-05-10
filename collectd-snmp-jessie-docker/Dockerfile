# VERSION 1.0
# AUTHOR: Donn Lee
# DESCRIPTION: Debian jessie collectd image.
# BUILD: docker build --rm -t donn/collectd-snmp-jessie-docker
# SOURCE: https://github.com/donnlee/collectd-docker

FROM donn/collectd-jessie-docker
MAINTAINER donn

# Never prompts the user for choices on installation/configuration of packages
ENV DEBIAN_FRONTEND noninteractive
ENV TERM linux
# Work around initramfs-tools running on kernel 'upgrade': <http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=594189>
ENV INITRD No

# Add non-free repo for snmp-mibs-downloader.
RUN cat /etc/apt/sources.list | sed -ne 's/jessie main/jessie main non-free/;p' > /tmp/sources.list \
    && mv /tmp/sources.list /etc/apt/

RUN apt-get update -y
RUN apt-get install -y snmp snmp-mibs-downloader
RUN apt-get clean

# Current dir is "/" at this point. And we are root.

# In prod, cleanup files.
RUN rm -rf \
    /var/lib/apt/lists/* \
    /tmp/* \
    /var/tmp/* \
    /usr/share/man \
    /usr/share/doc \
    /usr/share/doc-base

ADD collectd.conf.tpl /etc/collectd/collectd.conf.tpl
ADD run.sh /root/run.sh
RUN chmod +x /root/run.sh

CMD ["/root/run.sh"]
# Testing:
#CMD ["tail", "-f", "/dev/null"]

# Expose is not needed. collectd is sending to influxdb via 'network' plugin.
#EXPOSE 25826/udp

