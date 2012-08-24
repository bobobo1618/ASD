strings = require './Strings'
uuid = require 'node-uuid'
marked = require 'marked'

marked.setOptions {
  gfm: true
  pedantic: false
  sanitize: true
}

postTemplate = {
    shortname: uuid.v4()
    body: ''
    markup: ''
    title: ''
    tags: []
    date: new Date()
    dateModified: null
    author: null
    renderedBody: ''
}

renderers = {
    markdown: (text)->
        return marked.parse text
    htmlmixed: (text)->
        return text
}

requiredPostKeys = ['body', 'markup']
optionalPostKeys = ['title', 'tags', 'date', 'author', 'shortname']

validatePostData = (req, mpostcol, callback)->
    if req.body?
        body = postTemplate
        for key in requiredPostKeys
            if req.body[key]?
                body[key] = req.body[key]
            else
                callback 1, 0
        for key in optionalPostKeys
            if req.body[key]?
                body[key] = req.body[key]
        mpostcol.findOne {shortname:body.shortname}, (err, item)->
            if err?
                callback 1, 2
            else if item?
                callback 1, 1
            else
                body.renderedBody = renderers[body.markup] body.body
                callback null, body
    else
        callback 1, 0

init = (app, mpostcol, rclient)->

    app.get '/', (req, res)->
        mpostcol.find({}, {limit:10}).toArray (err, result) ->
            if !err
                res.render 'Home', {results: result, session:req.session}
            else
                res.render 'Error', {error: strings.dbError, session:req.session}

    app.get '/post', (req, res)->
        res.render 'Post', session:req.session

    app.post '/entries/', (req, res)->
        validatePostData req, mpostcol, (err, result)->
            if !err and result?
                mpostcol.insert result, {safe:true}, (err, mresult)->
                    if !err
                        console.dir mresult
                        res.redirect '/entries/'+result.shortname.toString()
                    else
                        res.render 'Error', {error: strings.dbError, session:req.session}
            else
                switch result
                    when 0
                        res.render 'Error', {error: strings.invalidRequestError, session:req.session}
                    when 1
                        res.render 'Error', {error: strings.itemExistsError, session:req.session}
                    when 2
                        res.render 'Error', {error: strings.dbError, session:req.session}
                    else
                        res.render 'Error', {error: strings.genericError, session:req.session}

    app.del '/entries/:shortname', (req, res)->

    app.put '/entries/entries/:shortname', (req, res)->

    app.get '/entries/:shortname', (req, res)->
        mpostcol.findOne {shortname: req.params.shortname}, (err, item)->
            if !err and item
                console.dir item
                res.render 'Entry', {post: item, session:req.session}
            else if !item
                res.render 'Error', {error: strings.notFoundError, session:req.session}
            else
                res.render 'Error', {error: strings.dbError, session:req.session}

    app.get '/entries/:yy/:mm/:dd/:shortname?', (req, res)->

    app.get '/login', (req,res)->
        res.render 'Login', {session:req.session}

exports.init = init
