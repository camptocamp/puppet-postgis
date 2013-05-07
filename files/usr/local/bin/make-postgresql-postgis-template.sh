#!/bin/sh

TMPL_NAME="template_postgis"

# TODO: add support for multiple/non-default clusters
PG_VERSION=$(pg_lsclusters --no-header | grep 5432 | awk '{ print $1 }')

case "$PG_VERSION" in
'8.3')
PG_POSTGIS="/usr/share/postgresql-8.3-postgis/lwpostgis.sql"
PG_SPATIAL_REF="/usr/share/postgresql-8.3-postgis/spatial_ref_sys.sql"
;;
'8.4'|'9.0'|'9.1')
PGIS_VERSION=$(ls -d /usr/share/postgresql/$PG_VERSION/contrib/postgis* | cut -d- -f2)
PG_POSTGIS="/usr/share/postgresql/$PG_VERSION/contrib/postgis-$PGIS_VERSION/postgis.sql"
PG_SPATIAL_REF="/usr/share/postgresql/$PG_VERSION/contrib/postgis-$PGIS_VERSION/spatial_ref_sys.sql"
;;
*)
echo "No support for $PG_VERSION in $0"
exit 1
;;
esac

test -e $PG_POSTGIS || (echo "File not found - $PG_POSTGIS" && exit 1)
test -e $PG_SPATIAL_REF || (echo "File not found - $PG_POSTGIS" && exit 1)

cat << EOF | psql -q
CREATE DATABASE $TMPL_NAME WITH template = template1;
UPDATE pg_database SET datistemplate = TRUE WHERE datname = '$TMPL_NAME';
EOF

createlang plpgsql $TMPL_NAME
psql -q -d $TMPL_NAME -f $PG_POSTGIS || exit 1
psql -q -d $TMPL_NAME -f $PG_SPATIAL_REF || exit 1

cat << EOF | psql -d $TMPL_NAME
GRANT ALL ON geometry_columns TO PUBLIC;
GRANT SELECT ON spatial_ref_sys TO PUBLIC;
VACUUM FREEZE;
EOF

