require 'coffee-script'
express = require 'express'
now = require 'now'

config = require './Config'

app = express.createServer()

app.configure ()->
    app.use '/static', express.static __dirname + '/Static'
    app.use express.logger()
    app.use express.bodyParser {uploadDir: './Uploads', keepExtensions: true}
    app.set setting, value for setting, value of config.esettings

everyone = now.initialize app

app.get '/', (req, res)->
    res.render 'Home'

app.post '/entries/', (req, res)->


app.del '/entries/:id', (req, res)->


app.put '/entries/:id', (req, res)->


app.get '/entries/:id', (req, res)->


app.get '/entries/:dd/:mm/:yy/:id?', (req, res)->


app.listen config.port, config.host

console.log 'Listening on '+config.host.toString()+':'+config.port.toString()