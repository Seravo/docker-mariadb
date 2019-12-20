FROM ypcs/debian:buster

ARG APT_PROXY
ARG VCS_REF
LABEL org.label-schema.vcs-ref=$VCS_REF

RUN \
    /usr/lib/docker-helpers/apt-setup && \
    /usr/lib/docker-helpers/apt-upgrade && \
    apt-get -y install \
        gosu \
        mariadb-server \
        pwgen && \
    /usr/lib/docker-helpers/apt-cleanup

RUN \
    sed -ri 's/^user\s/#&/' /etc/mysql/my.cnf /etc/mysql/conf.d/* && \
    rm -rf /var/lib/mysql && \
    mkdir -p /var/lib/mysql /var/run/mysqld && \
    chown -R mysql:mysql /var/lib/mysql /var/run/mysqld && \
    chmod 777 /var/run/mysqld

COPY docker.cnf /etc/mysql/conf.d/docker.cnf

RUN mkdir /docker-entrypoint-initdb.d

VOLUME /var/lib/mysql

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

ENV LC_ALL en_US.UTF-8
ENV LC_LANG en_US.UTF-8

CMD ["mysqld"]

