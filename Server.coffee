require 'coffee-script'
express = require 'express'
riak = require 'riak-js'
#now = require 'now'

config = require './Config'

app = express.createServer()

app.configure ()->
    app.use '/static', express.static __dirname + '/Static'
    app.use express.logger()
    app.use express.bodyParser {uploadDir: './Uploads', keepExtensions: true}
    app.set setting, value for setting, value of config.esettings

#db = riak.getClient (config.riak.host || '127.0.0.1', config.riak.port || 8098)

postBucket = config.riak.postBucket

#everyone = now.initialize app

app.get '/', (req, res)->
    res.render 'Home'

app.get '/post', (req, res)->
    res.render 'Post'

app.post '/entries/:id?', (req, res)->
    if req.body 
        if req.params.id
            db.save postBucket, req.params.id, req.body
        else
            console.dir req.body
    res.end 'Done'

app.del '/entries/:id', (req, res)->
    db.remove postBucket, req.params.id
    res.end 'Done'

app.put '/entries/:id', (req, res)->
    db.update postBucket, req.params.id, req.body
    res.end 'Done'

app.get '/entries/:id', (req, res)->
    db.get postBucket, req.params.id, (err, entry, meta)->
    res.end 'Done'


app.get '/entries/:yy/:mm/:dd/:id?', (req, res)->
    res.end 'Done'
    
app.listen config.port, config.host

console.log 'Listening on '+config.host.toString()+':'+config.port.toString()