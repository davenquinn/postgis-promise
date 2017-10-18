# postgis-promise

This module is a transparent wrapper of the `pg-promise` library that sets
up several `postgis` query types to automatically parse geometries, by checking
the database for the correct OIDs at runtime. This check is guaranteed to
happen prior to any queries being run.

The only API change to the `pg-promise` API is the inclusion of a {geoJSON} tag
in the `pg-promise` initialization library, which is defaulted to `false`.
