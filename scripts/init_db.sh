#/bin/bash

export POSTGRES_USER=root
export POSTGRES_PASSWORD=root
export POSTGRES_DB=root
export PGPASSWORD=$POSTGRES_PASSWORD
export SQL_DIR=/opt/postgres/sql

DART_USER=dart
DART_PASSWORD=dart_pass
DART_DB=dart_db

# Start postgres entrypoint script in background and cache PID
docker-entrypoint.sh postgres -c config_file=/etc/postgresql/postgresql.conf &
DC_PID=$!

i=1
while [ "$i" -ne "0" ] ;
  do
    pg_isready -U $POSTGRES_USER
    i=$?
  done


i=0
while [ "$i" != "1" ] ;
  do
    i="$(psql -U $POSTGRES_USER -d $POSTGRES_DB -tAc "SELECT 1 FROM pg_database WHERE datname='$POSTGRES_DB';" )"
  done

echo "Configuring dart user"
psql -U $POSTGRES_USER -d $POSTGRES_DB -c "
CREATE USER ${DART_USER} WITH
NOCREATEROLE
NOCREATEDB
ENCRYPTED PASSWORD '${DART_PASSWORD}';"

echo "Configuring dart database"
psql -U $POSTGRES_USER -d $POSTGRES_DB -c "CREATE DATABASE ${DART_DB} OWNER ${DART_USER} ENCODING 'UTF8'"

psql -f $SQL_DIR/tables.sql -U $POSTGRES_USER -d $DART_DB
DART_TABLES="reader_output,sams_progress,publish_cache,pipeline_status,ontology_registry,user_data"

psql -U $POSTGRES_USER -d $DART_DB -c "GRANT SELECT, UPDATE, INSERT, DELETE, TRUNCATE ON ${DART_TABLES} TO ${DART_USER};"
psql -U $POSTGRES_USER -d $DART_DB -c "GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO ${DART_USER};"



# Closest thing in bash script to fg
wait "$DC_PID"
