require 'coffee-script'
express = require 'express'
riak = require 'riak-js'
mongo = require 'mongodb'

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

mdb = 0
mpostcol = 0

app.get '/', (req, res)->
    res.render 'Home'

app.get '/post', (req, res)->
    res.render 'Post'

app.post '/entries/:id?', (req, res)->
    if req.body
        body = req.body
        if req.params.id
            body.id = req.params.id
            mpostcol.findOne {id:req.params.id}, (err, item)->
                if item
                    res.render 'Error', {error:'ID is in use.'}
                else if err
                    res.render 'Error', {error:err.toString()}
                else
                    mpostcol.insert body, {safe:true}, (err, result)->
                        if !err
                            res.render 'Error', {error:'Success!'}
                        else
                            res.render 'Error', {error:err.toString()}
        else
            res.render 'Error', {error:'No ID was received.'}
    else
        res.render 'Error', {error:'No POST data was received.'}

app.del '/entries/:id', (req, res)->
    mpostcol.remove {id:req.params.id}
    res.end 'Done'

app.put '/entries/:id', (req, res)->
    riakdb.update rPostBucket, req.params.id, req.body
    res.end 'Done'

app.get '/entries/:id', (req, res)->
    mpostcol.findOne {id:req.params.id}, (err, item)->
        if !err and item
            res.writeHead 200, {'Content-Type':'text/plain'}
            res.end item.body
        else if err
            res.render 'Error', {error: err.toString()}
        else
            res.render 'Error', {error:'Post not found.'}

app.get '/entries/:yy/:mm/:dd/:id?', (req, res)->
    res.end 'Done'

mPostDB.open (err,db)->
    if !err
        console.log 'MongoDB connected successdully.'
        mdb = db
        db.createCollection config.mongo.postCol, (err, collection)->
            if !err
                console.log 'Collection access successful.'
                mpostcol = collection
                app.listen config.port, config.host
                console.log 'Listening on '+config.host.toString()+':'+config.port.toString()

            else
                console.log 'Collection access failed.'
    else
        console.log err