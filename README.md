# postgis-promise

This module is a transparent wrapper around the excellent
[`pg-promise`](https://vitaly-t.github.io/pg-promise/index.html) library
that allows the automatic parsing
of several [PostGIS](https://postgis.net/) `Geometry` types to GeoJSON.

The library matches types to the correct OIDs
on initialization, prior to any queries being run.
It is based on the [`pg-postgis-types`](https://github.com/zhm/pg-postgis-types)
and [`wkx`](https://github.com/cschwarz/wkx) libraries.

The only change to the `pg-promise` API is the inclusion of a {geoJSON} tag
in the library initialization options. This optional key, which
is `false` by default, automatically marshals `Geometry` types to GeoJSON
upon query deserialization. It is a cleaner and (probably) more performant
alternative to littering your SQL with `ST_AsGeoJSON(...)` functions.

If you want to deserialize a single geometry without wrapping the entire
database connection, use the [`wkx`](https://github.com/cschwarz/wkx)
geometry parser directly.

2017 — 2019, Daven Quinn
