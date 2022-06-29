FROM ghcr.io/seravo/ubuntu:jammy

ARG APT_PROXY
ARG VCS_REF

RUN sed -i 's/main$/main universe/g' /etc/apt/sources.list && \
    apt-setup && \
    apt-upgrade && \
    DEBIAN_FRONTEND=noninteractive apt-get --assume-yes install \
        galera-4 \
        gosu \
        mariadb-server \
        pwgen \
        tzdata && \
    apt-cleanup

RUN \
    sed -ri 's/^user\s/#&/' /etc/mysql/my.cnf /etc/mysql/conf.d/* && \
    rm -rf /var/lib/mysql && \
    mkdir -p /var/lib/mysql /var/run/mysqld && \
    chown -R mysql:mysql /var/lib/mysql /var/run/mysqld && \
    sed -i 's/^bind-address/#bind-address/g' /etc/mysql/*.cnf /etc/mysql/conf.d/*.cnf /etc/mysql/mariadb.conf.d/*.cnf && \
    chmod 777 /var/run/mysqld

COPY docker.cnf /etc/mysql/conf.d/docker.cnf

RUN mkdir /docker-entrypoint-initdb.d

VOLUME /var/lib/mysql

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

ENV LC_ALL C.UTF-8
ENV LC_LANG C.UTF-8

CMD ["mariadbd"]
HEALTHCHECK --interval=30s --timeout=1s --start-period=30s --retries=3 CMD mysql -e 'SELECT NOW();'
