require 'coffee-script'
express = require 'express'

riak = require 'riak-js'
mongo = require 'mongodb'
redis = require 'redis'

requests = require './App/Requests'

config = require './Config'

app = express.createServer()

app.configure ()->
    app.use '/static', express.static __dirname + '/Static'
    app.use express.logger()
    app.use express.cookieParser()
    app.use express.bodyParser {uploadDir: './Uploads', keepExtensions: true}
    app.use express.session {secret:'sy9h6dyhuliew5uh89soguholsd8fs7hyolsdg'}
    app.set setting, value for setting, value of config.esettings

riakdb = riak.getClient {
    host:(config.riak.host || '127.0.0.1')
    port:(config.riak.port || 8098)
}

mongos = new mongo.Server config.mongo.host, config.mongo.port, config.mongo.options
mPostDB = new mongo.Db config.mongo.postDB, mongos

rPostBucket = config.riak.postBucket

mdb = 0
mpostcol = 0

mPostDB.open (err,db)->
    if !err
        console.log 'MongoDB connected successdully.'
        mdb = db
        db.createCollection config.mongo.postCol, (err, collection)->
            if !err
                console.log 'Collection access successful.'
                mpostcol = collection
                rclient = redis.createClient()
                requests.init app, mpostcol, rclient
                app.listen config.port, config.host
                console.log 'Listening on '+config.host.toString()+':'+config.port.toString()

            else
                console.log 'Collection access failed.'
    else
        console.log err
