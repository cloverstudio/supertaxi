var express = require('express');
var http = require('http');

var Conf = require('./lib/init.js');

Conf.host = "localhost";
Conf.port = 8081;
Conf.dbCollectionPrefix = '';
Conf.databaseUrl = "mongodb://localhost/supertaxitest";

// initialization
var app = express();
var server = http.createServer(app);
var port = Conf.port;

var WebAPI = require('./WebAPI/WebAPIMain');
var DatabaseManager = require('./lib/DatabaseManager');

console.log('Starting SuperTaxi Server...');

DatabaseManager.init(function(success){

    if(!success){

        console.log('Failed to connect DB');
        process.exit(1);

    } else {

        WebAPI.init(app);

        server.on('connection', function(socket) {
            socket.setTimeout(30000);
        })

        server.listen(Conf.port, function(){
            console.log('Server listening on port ' + Conf.port + '!');
        });

    }

});

module.exports = server