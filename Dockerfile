FROM ypcs/debian:stretch

ARG VCS_REF
LABEL org.label-schema.vcs-ref=$VCS_REF

RUN \
    /usr/local/sbin/docker-upgrade && \
    apt-get -y install mariadb-server gosu && \
    /usr/local/sbin/docker-cleanup

RUN \
    sed -ri 's/^user\s/#&/' /etc/mysql/my.cnf /etc/mysql/conf.d/* && \
    rm -rf /var/lib/mysql && \
    mkdir -p /var/lib/mysql /var/run/mysqld && \
    chown -R mysql:mysql /var/lib/mysql /var/run/mysqld && \
    chmod 777 /var/run/mysqld && \
    find /etc/mysql/ -name '*.cnf' -print0 | xargs -0 grep -lZE '^(bind-address|log)' | xargs -rt -0 sed -Ei 's/^(bind-address|log)/#&/' && \
    echo '[mysqld]\nskip-host-cache\nskip-name-resolve' > /etc/mysql/conf.d/docker.cnf

RUN mkdir /docker-entrypoint-initdb.d

VOLUME /var/lib/mysql

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 3306
CMD ["mysqld"]

