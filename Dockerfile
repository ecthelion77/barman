# Keep this argument
ARG REGISTRY=docker.io
FROM ${REGISTRY}/library/alpine:3.7

# Informations on this image
LABEL maintainer="Athena Core Team" \
    vendor="Thales Services" \
    description="Barman server"

# App version
ENV APP_VERSION 2.2

RUN echo "@testing http://nl.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories
RUN apk update \
    && apk add barman@testing

ENV \ 
BARMAN_DATA_DIR=/var/lib/barman \ 
BARMAN_LOG_LEVEL=INFO \ 
BARMAN_CRON_SCHEDULE="* * * * *" \ 
BARMAN_BACKUP_SCHEDULE="0 1 * * *" \ 
BARMAN_RECEIVE_WAL_TIMEOUT=10 \ 
BARMAN_BACKUP_RETENTION_DAYS=30 \ 
BARMAN_MINIMUM_REDUNDANCY=0 \ 
DB_BACKUP_METHOD=postgres \ 
DB_HOST=postgresql \ 
DB_PORT=5432 \ 
DB_SUPERUSER=gitlab \ 
DB_SUPERUSER_PASSWORD=s3cR3t \ 
DB_NAME=gitlab \ 
DB_REPLICATION_USER=standby \ 
DB_REPLICATION_PASSWORD=standby \ 
DB_SLOT_NAME=barman

VOLUME ${BARMAN_DATA_DIR}
WORKDIR ${BARMAN_DATA_DIR}

COPY bin/docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["cron", "-l", "0", "-f"]

