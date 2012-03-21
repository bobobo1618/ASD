options = {
    port: process.env.port || 39950,
    host: '0.0.0.0',
    esettings:{
        views: __dirname + '/Views',
        'view engine': 'jade',
        'case sensitive routes': true
        'view options': {layout:false}
    }
}

module.exports = options