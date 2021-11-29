FROM mongo:4.0
USER root

COPY 01_init_rs.sh /docker-entrypoint-initdb.d
RUN chown mongodb: /docker-entrypoint-initdb.d/01_init_rs.sh

USER mongodb