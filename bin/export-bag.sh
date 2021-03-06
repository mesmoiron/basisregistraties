#!/bin/bash

echo "CREATE INDEX adres_postcode ON bagactueel.adres (postcode varchar_pattern_ops);" | psql -U postgres

echo "\\copy (select distinct substring(postcode from 1 for 4) as pp4 from bagactueel.adres order by pp4) to '/tmp/bag_csv/postcodes4pp.csv';" | psql -U postgres

cat /tmp/bag_csv/postcodes4pp.csv | while read i; do
	echo "\\copy (select distinct openbareruimtenaam, huisnummer, huisletter, huisnummertoevoeging, postcode, woonplaatsnaam, gemeentenaam, provincienaam, typeadresseerbaarobject, cast(ST_X(ST_Transform(geopunt, 4326)) as numeric(9,6)) as longitude, cast(ST_Y(ST_Transform(geopunt, 4326)) as numeric(8,6)) as latitude from bagactueel.adres where postcode like '$i%' order by postcode, openbareruimtenaam, huisnummer, huisletter, huisnummertoevoeging) to '/tmp/bag_csv/$i.csv' csv header;" | psql -U postgres psql
done

