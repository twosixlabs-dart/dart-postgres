FROM postgres:12

RUN mkdir -p /opt/postgres/sql

COPY scripts/* /opt/postgres/
COPY sql/* /opt/postgres/sql/
COPY conf/postgresql.conf /etc/postgresql/postgresql.conf

ENTRYPOINT "/opt/postgres/init_db.sh"
