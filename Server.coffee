require 'coffee-script'
express = require 'express'
riak = require 'riak-js'
mongo = require 'mongodb'
#now = require 'now'

config = require './Config'

app = express.createServer()

app.configure ()->
    app.use '/static', express.static __dirname + '/Static'
    app.use express.logger()
    app.use express.bodyParser {uploadDir: './Uploads', keepExtensions: true}
    app.set setting, value for setting, value of config.esettings

riakdb = riak.getClient {
    host:(config.riak.host || '127.0.0.1')
    port:(config.riak.port || 8098)
}

mongos = new mongo.Server config.mongo.host, config.mongo.port, config.mongo.options
mPostDB = new mongo.Db config.mongo.postDB, mongos

rPostBucket = config.riak.postBucket

#everyone = now.initialize app

app.get '/', (req, res)->
    res.render 'Home'

app.get '/post', (req, res)->
    res.render 'Post'

app.post '/entries/:id?', (req, res)->
    if req.body 
        if req.params.id
            if riakdb.exists rPostBucket, req.params.id
                res.render 'Error', {error:'ID is in use.'}
            else
                riakdb.save rPostBucket, req.params.id, req.body
                res.render 'Error', {error:'Success!'}
        else
            res.render 'Error', {error:'No ID was received.'}
    else
        res.render 'Error', {error:'No POST data was received.'}

app.del '/entries/:id', (req, res)->
    riakdb.remove rPostBucket, req.params.id
    res.end 'Done'

app.put '/entries/:id', (req, res)->
    riakdb.update rPostBucket, req.params.id, req.body
    res.end 'Done'

app.get '/entries/:id', (req, res)->
    riakdb.get rPostBucket, req.params.id, (err, entry, meta)->
        if !err
            res.writeHead 200, {'Content-Type':'text/plain'}
            res.end entry.body
        else
            res.render 'Error', {error: err.toString()}

app.get '/entries/:yy/:mm/:dd/:id?', (req, res)->
    res.end 'Done'
    
app.listen config.port, config.host

console.log 'Listening on '+config.host.toString()+':'+config.port.toString()