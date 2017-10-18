library = require 'pg-promise'
postgis = require('pg-postgis-types').default
{Buffer} = require 'buffer'
{Geometry} = require 'wkx'

defaultToGeoJSON = (parser)->(args...)->
  res = parser.apply @, args
  v = res.toGeoJSON()
  delete res.toGeoJSON
  v.source = -> res
  return v

wrapConfiguredLibrary = (pgp, useGeoJSON)->

  newPGP = ->
    dbObj = pgp.apply @, arguments
    # Start setting up parsers
    Promise = dbObj.$config.promise

    fetcher = (sql, cb)->
      dbObj.query sql
        .then (rows)->
          cb(null, rows)

    dbid = "db"
    p = new Promise (resolve, reject)->
      postgis fetcher, dbid, (err)->
        reject() if err?
        if useGeoJSON
          ## Modify the type parser to return geoJSON object by
          ## default, with a raw object attached as geom.source()
          {getTypeParser, setTypeParser} = pgp.pg.types
          # This is a hack to get the internal OIDs and relies on an
          # implementation detail in the `pg-postgis-types` library.
          oidmap = postgis.oids["postgis-#{dbid}"]
          for oid in Object.values(oidmap)
            parser = getTypeParser oid
            setTypeParser oid, defaultToGeoJSON(parser)

        resolve()

    # Make sure all functions on DB object
    # are applied within promises.
    for k,v of dbObj
      dbObj[k] = (args...)->
        p.then ->
          v.apply @, args
    return dbObj

  Object.assign newPGP, pgp

newLibrary = (opts={})->
  useGeoJSON = opts.geoJSON or true
  delete opts.geoJSON
  pgp = library(opts)
  return wrapConfiguredLibrary(pgp, useGeoJSON)

module.exports = newLibrary
