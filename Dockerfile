# Set base to Debian scratch
FROM debian:scratch

# install base packages
ENV DEBIAN_FRONTEND=noninteractive
WORKDIR /tmp

RUN apt-get update -y && \
    apt-get install -y apt-utils && \
    apt-get install -y \
      ca-certificates \
      libpython2.7 \
      jq \
      tor \
      net-tools \
      cron \
      nano \
      mc \
      greenlet \
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
    mkdir -p /mnt/media/playlists && \

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
ADD ace.hls_parser.sh /mnt/media/playlists/ace.hls_parser.sh
RUN chmod +x /mnt/media/playlists/ace.hls_parser.sh
RUN /mnt/media/playlists/ace.hls_parser.sh
ADD start.sh /usr/bin/start.sh
RUN chmod +x /usr/bin/start.sh

RUN rm -rf /tmp/*

EXPOSE 8000 8621 62062 9944 9903 6878
VOLUME /etc/aceproxy

WORKDIR /
ENTRYPOINT ["/usr/bin/start.sh"]
