# Set base to Debian jessie
FROM debian:jessie

# install base packages
ENV DEBIAN_FRONTEND=noninteractive
WORKDIR /tmp

RUN apt-get update -y && \
    apt-get install -y apt-utils && \
    apt-get install -y \
      ca-certificates \
      libpython2.7 \
      jq \ 
      net-tools \
      python-apsw \
      python-gevent \
      python-m2crypto \
      python-psutil \
      python-requests \
      supervisor \
      unzip \
      wget \
    && \
    apt-get install -y --no-install-recommends vlc-nox && \

# create user to run aceproxy
    useradd --system --create-home --no-user-group --gid nogroup tv && \

# install acestream-engine
    wget  -o - http://dl.acestream.org/linux/acestream_3.1.16_debian_8.7_x86_64.tar.gz && \
    tar --show-transformed-names --transform='s/acestream_3.1.16_debian_8.7_x86_64/acestream/' -vzxf acestream_3.1.16_debian_8.7_x86_64.tar.gz && \
    mv acestream /usr/share && \
    rm -rf /tmp/* && \

# obtain and unpack aceproxy
    wget -o - https://github.com/AndreyPavlenko/aceproxy/archive/master.zip -O aceproxy.zip && \
    unzip -d /home/tv aceproxy.zip && \
    mv /home/tv/aceproxy-* /home/tv/aceproxy && \
    rm -rf /tmp/*

# add services
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD supervisor/supervisord.conf /etc/supervisor/supervisord.conf
ADD start.sh /usr/bin/start.sh
RUN chmod +x /usr/bin/start.sh

RUN echo 'deb http://ftp.de.debian.org/debian/ stretch main contrib non-free' > /etc/apt/sources.list.d/debianstretch.list
RUN apt-get update -y
RUN apt-get install -y nano mc python-psutil python-gevent python-greenlet
RUN rm -rf /tmp/*

EXPOSE 22 8000 8621 62062 9944 9903
VOLUME /etc/aceproxy

WORKDIR /
ENTRYPOINT ["/usr/bin/start.sh"]
