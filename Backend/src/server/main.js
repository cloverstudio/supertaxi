var express = require('express');
var http = require('http');

var Conf = require('./lib/init.js');

// initialization
var app = express();
var server = http.createServer(app);
var port = Conf.port;

var WebAPI = require('./WebAPI/WebAPIMain');
var DatabaseManager = require('./lib/DatabaseManager');
var path = require('path');

console.log('Starting SuperTaxi Server...');

DatabaseManager.init(function(success){

    if(!success){

        console.log('Failed to connect DB');
        process.exit(1);

    } else {

        // starts process in valid directory (backend)
        process.chdir(path.resolve(__dirname, "../.."));

        WebAPI.init(app);

        server.on('connection', function(socket) {
            socket.setTimeout(30000);
        })

        server.listen(Conf.port, function(){
            console.log('Server listening on port ' + Conf.port + '!');
        });

    }

});
