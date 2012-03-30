options = {
    port: process.env.port || 39950
    host: '0.0.0.0'
    esettings:{
        views: __dirname + '/Views'
        'view engine': 'jade'
        'case sensitive routes': true
        'view options': {layout:false}
    }
    riak: {
        host: '127.0.0.1'
        port: 8098
        postBucket: 'testBucket'
    }
    mongo: {
        host: '127.0.0.1'
        port: 27017
        options: {
            auto_reconnect: true
        }
        postDB: 'test'
        postCol: 'posts'
    }
}

module.exports = options
